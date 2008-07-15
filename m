Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYGOPMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYGOPMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYGOPLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:11:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbYGOPLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:11:53 -0400
Date: Tue, 15 Jul 2008 08:10:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: David Woodhouse <dwmw2@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487C5ABE.2010907@garzik.org>
Message-ID: <alpine.LFD.1.10.0807150808050.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> 
 <487C09EB.1050903@garzik.org>  <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>  <487C1648.5070409@garzik.org>  <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>  <487C500F.8000109@garzik.org> <1216107418.27455.236.camel@shinybook.infradead.org>
 <487C5ABE.2010907@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Jeff Garzik wrote:
> 
> With this change, there are several exceptions where this is not the case,
> across all driver types -- media, wan, char, net, scsi, ...
> 
> Package manifests, build scripts and other details MUST be updated, or these
> drivers will not work as they did in kernels <= 2.6.26.

Umm. I complained six months ago when the e1000e driver took over, and the 
e1000 driver stopped working for me, and you suddenly had to know which 
version of the e1000 you had - even though there was not any sane way to 
tell them apart.

Ingo _still_ complains about that occasionally.

What did you do? You didn't care.

Now you suddenly do care that some driver needs additional love and 
learning.

I call bullshit. You don't like the change - ok. But stop making bogus 
arguments about it.

			Linus
