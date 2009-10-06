Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbZJFPbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbZJFPbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbZJFPbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:31:35 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34030 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858AbZJFPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:31:35 -0400
Message-ID: <4ACB626C.8090503@s5r6.in-berlin.de>
Date: Tue, 06 Oct 2009 17:29:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu>
In-Reply-To: <20091006144449.GA23078@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> I.e. i think it's a fact that right now our release version is highly 
> deceptive during the merge window.
[...]
> One option would be to make LOCALVERSION_AUTO compulsory.
> 
> Or to add a tweak to the naming, something like:
> 
>  v2.6.31
>  v2.6.31+
>  v2.6.32-rc1
>  v2.6.32-rc1+
[...]
> ... for the sole purpose of warning people that anything they pull after 
> v2.6.31 got released is (wildly!) not vanilla v2.6.31 anymore.

If this scheme is meant to be something on which people can rely on,
everybody who commits to a tree from which Linus pulls from would have
to base their branches onto those ...+ commits, always.
-- 
Stefan Richter
-=====-==--= =-=- --==-
http://arcgraph.de/sr/
