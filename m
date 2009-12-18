Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZLRUQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZLRUQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZLRUQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:16:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbZLRUQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:16:08 -0500
Date: Fri, 18 Dec 2009 12:15:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Hounschell <markh@compro.net>
cc: Mark Hounschell <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       linux-kernel@vger.kernel.org, fdutils@fdutils.linux.lu
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28 (Was:
 Re: Cannot format floppies under kernel 2.6.*?)
In-Reply-To: <4B2BE05B.9050006@compro.net>
Message-ID: <alpine.LFD.2.00.0912181213540.3712@localhost.localdomain>
References: <4AFB3962.2020106@ntlworld.com> <4B292D84.5040306@compro.net> <4B29624F.2080109@knaff.lu> <4B2A3805.8040707@compro.net> <4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net> <4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu>
 <4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu> <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff! .lu> <4B2A6394.3080705@knaff.lu> <alpine.LFD.2.00.0912170916420.15740@localhost.locald!
 omain> <4B2A98BB.5080406@knaff.lu> <alpine.LFD.2.00.0912171256560.15740@localhost.localdomain> <4B2AAC87.5000703@knaff.lu> <alpine.LFD.2.00.0912171440420.15740@localhost.localdomain> <4B2ABDC8.6090104@knaff.lu> <4B2B4485.6000305@cfl.rr.com>
 <4B2B5F86.1090403@cfl.rr.com> <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain> <4B2B9F9F.7040802@compro.net> <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain> <4B2BE05B.9050006@compro.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Mark Hounschell wrote:
> 
> It looks like I may have to back up and first find the points that, let me,
> and stop me,  booting with the HPET enabled. Before I change direction, can
> the git-bisect start sequence use the SHA1 id for the starting 'goods' and
> 'bads'? I don't see reference to that in the doc.

You can always use a SHA1 id instead of a tag. So when you did

	git bisect good v2.6.17.4

you could always have replaced that "v2.6.17.4" with the SHA1 of the 
commit.

In git, the SHA1 ID's are the "real" names - the tags and branch names are 
purely for human-readable decoration. Git always turns them into SHA1 id's 
internally.

		Linus
