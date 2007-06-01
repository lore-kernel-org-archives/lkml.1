Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbXFABhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbXFABhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbXFABhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:37:24 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134AbXFABhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:37:23 -0400
Date: Thu, 31 May 2007 18:37:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
cc: Gregor Jasny <gjasny@googlemail.com>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
In-Reply-To: <465F6F48.8080804@gmail.com>
Message-ID: <alpine.LFD.0.98.0705311830360.26602@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
  <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com> 
 <46599E6B.1000209@pobox.com>  <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com>
  <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org> 
 <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com> 
 <465AA536.6080608@gmail.com> <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com>
 <465BF244.5080200@gmail.com> <alpine.LFD.0.98.0705290924350.26602@woody.linux-foundation.org>
 <465F6F48.8080804@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Tejun Heo wrote:
>
> Gregor's cdrom has broken SRST support which is extremely rare and
> broken.

Well, the concept is neither rare nor arguably all that broken. 

The paper standards floating around in the industry are so much toilet 
paper. The only standard that seems to really matter is what Windows has 
traditionally done. We may not like it, but there it is...

This bites us more when it comes to the real el-cheapo stuff, notably when 
it comes to various USB mass storage things (which have some random 
USB->flash controller cobbled together by a senile llama on crack), and is 
almost unheard of for anythign that is "server-grade", but when it comes 
to no-brand random devices, it really does tend to be the case that the 
only testing they ever had was using Windows.

And hardware is seldom any different from software: if it wasn't tested, 
it probably doesn't work.

So it would be good if somebody knew what the Windows ID/startup sequence 
was/is. I think we figured it out by trial-and-error for the USB mass 
storage stuff. But it tends to boil down to: don't do things that aren't 
absolutely required (for SCSI, it was things like not asking for mode 
pages that weren't absolutely required, because some devices wouldn't 
support it, and would simply lock up if you did so!)

			Linus
