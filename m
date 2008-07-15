Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbYGOQxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbYGOQxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYGOQxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:53:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45301 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbYGOQxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:53:41 -0400
Message-ID: <487CD60E.7000801@garzik.org>
Date: Tue, 15 Jul 2008 12:53:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Woodhouse <dwmw2@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>  <487C09EB.1050903@garzik.org>  <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>  <487C1648.5070409@garzik.org>  <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>  <487C500F.8000109@garzik.org> <1216107418.27455.236.camel@shinybook.infradead.org> <487C5ABE.2010907@garzik.org> <alpine.LFD.1.10.0807150808050.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807150808050.3017@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 15 Jul 2008, Jeff Garzik wrote:
>> With this change, there are several exceptions where this is not the case,
>> across all driver types -- media, wan, char, net, scsi, ...
>>
>> Package manifests, build scripts and other details MUST be updated, or these
>> drivers will not work as they did in kernels <= 2.6.26.
> 
> Umm. I complained six months ago when the e1000e driver took over, and the 
> e1000 driver stopped working for me, and you suddenly had to know which 
> version of the e1000 you had - even though there was not any sane way to 
> tell them apart.
> 
> Ingo _still_ complains about that occasionally.
> 
> What did you do? You didn't care.

Completely false -- what was the outcome?  The breakage complained about 
was fixed, we made sure Ingo had proper defconfig entries, the changes 
to e1000e were pushed back.

That's a lot of taking-feedback-from-others that you define as "didn't 
care."

	Jeff



