Return-Path: <linux-kernel-owner+w=401wt.eu-S935556AbZLQSVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935556AbZLQSVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935356AbZLQSVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:21:45 -0500
Received: from khc.piap.pl ([195.187.100.11]:37016 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935257AbZLQSVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:21:44 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alain Knaff <alain@knaff.lu>, markh@compro.net, fdutils@fdutils.linux.lu,
       linux-kernel@vger.kernel.org
Subject: Re: DMA cache consistency bug introduced in 2.6.28
References: <4AFB3962.2020106@ntlworld.com> <4B27983F.5090600@compro.net>
	<4B27EF18.7050101@knaff.lu> <4B28FDEB.3030800@compro.net>
	<4B290029.90602@knaff.lu> <4B2901DB.8040403@compro.net>
	<4B29052B.9070406@knaff.lu> <4B292D84.5040306@compro.net>
	<4B29624F.2080109@knaff.lu> <4B2A3805.8040707@compro.net>
	<4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net>
	<4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu>
	<4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu>
	<4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu>
	<4B2A5192.6090602@compro.net> <4B2A6394.3080705@knaff.lu>
	<alpine.LFD.2.00.0912170916420.15740@localhost.localdomain>
Date: Thu, 17 Dec 2009 19:21:40 +0100
In-Reply-To: <alpine.LFD.2.00.0912170916420.15740@localhost.localdomain>
	(Linus Torvalds's message of "Thu, 17 Dec 2009 09:27:56 -0800 (PST)")
Message-ID: <m3aaxhjwaz.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On x86, where all caches are supposed to be totally coherent (except for 
> I$ under very special circumstances),

BTW SWIOTLB is a non-coherent "cache" in some sense, though I'd be
surprised if it's related. Anyway mentioning $CPU and $RAM at the very
least would be a good idea in such cases.
-- 
Krzysztof Halasa
