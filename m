Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYGORzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYGORzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYGORzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:55:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35681 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbYGORzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:55:07 -0400
Message-ID: <487CE471.9060808@garzik.org>
Date: Tue, 15 Jul 2008 13:54:57 -0400
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
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>  <487C09EB.1050903@garzik.org>  <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>  <487C1648.5070409@garzik.org>  <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>  <487C500F.8000109@garzik.org> <1216107418.27455.236.camel@shinybook.infradead.org> <487C5ABE.2010907@garzik.org> <alpine.LFD.1.10.0807150808050.3017@woody.linux-foundation.org> <487CDB85.3050208@garzik.org> <alpine.LFD.1.10.0807151024220.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151024220.3017@woody.linux-foundation.org>
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
>> The changes are good,
>>
>> They just don't need to break stuff.
>>
>> Which they do.
> 
> If you were serious about that, then you'd be suggesting _fixes_.

The fix was suggested from day one:  permit firmware-in-module, which 
I've already said I will work on...  provided its not dead on arrival.

Other fixes I've stated in these threads I want to tackle:

* newly separated firmware should live alongside the driver

* driver author should be able to deliver binary firmware direct from 
vendor, without any ihex or C-source-code mangling.


> I'm not seeing you do that. I'm just seeing non-productive "we should 
> never have changed" emails.

The emails are "this change should not contain obvious breakages"

To review the parts you've apparently missed, the problems and 
regressions I have found during review were

- Kconfig produced non-working drivers.  10+ skilled kernel hackers hit 
this.  I complained, was called silly, pointless, and having a tantrum. 
  Then, the issue was fixed, and kernel hackers could boot again.

- the normal build process produced non-working drivers.  A couple more 
skilled kernel hackers hit this one.  Build process regression was 
OBVIOUS.  Again, fixing this was called pointless and silly.  Again, it 
got fixed.  Again, kernel hackers started working again.

Now we have one last major regression hole to fix -- firmware-in-module.


> See my emails about what can be _productive_ avenues to explore. As it is, 
> I have yet to see a _single_ productive email from you. 

Strange, considering that it has been me who pointed out problems that 
would -- and did -- hit other kernel hackers, and those problems after 
much complaining and insulting got fixed.

	Jeff



