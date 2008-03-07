Return-Path: <linux-kernel-owner+w=401wt.eu-S1759744AbYCGGKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbYCGGKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYCGGKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:10:41 -0500
Received: from smtp.seznam.cz ([77.75.72.43]:41318 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753562AbYCGGKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:10:40 -0500
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Fri, 07 Mar 2008 07:10:35 +0100
MIME-Version: 1.0
Subject: Re: block layer / FS question: x86_32bit with LBD, 20 TB RAID volume => funny issues
Message-ID: <47D0EA6B.18428.A235AEC4@Frantisek.Rysanek.post.cz>
In-reply-to: <75b66ecd0803061905n5c06663cv2b75659917461199@mail.gmail.com>
References: <47D06F77.29711.A05566EC@Frantisek.Rysanek.post.cz>, <75b66ecd0803061905n5c06663cv2b75659917461199@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.32@12660
X-Seznam-User: frantisek.rysanek@post.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Mar 2008 at 4:05, Lee Revell wrote:
> >  I didn't even try Ext3, I know it's not appropriate for this sort of
> >  capacity.
> 
> Where did you get that idea?
>
Hmm... Google can find sources on the 'net claiming that Ext3 has a 
maximum of 2 or 4 TB. Nice to know that I'm wrong, I'll test this 
right away :-)
 
> Are you sure the hardware is not faulty?
>
I'm pretty sure. 
I know what it looks like when one of those 1TB drives has a problem 
it would prefer not to talk about in SMART (hint: only one disk 
activity LED out of 24 keeps blinking). Nowadays I have to handle 
several such drives in every new RAID unit delivered. 
When such a drive times out past some margin, say half a minute, the 
Linux kernel reports a SCSI CMD timeout, or rather, the RAID 
controller runs out of patience sooner than the kernel, the array 
gets degraded and keeps going on in degraded mode. So if the RAID 
controller itself goes out for lunch, Linux definitely complains. 
I've also seen a number of sly SCSI parity errors / general bus 
impedance problems, all of which yielded a proper error within half a 
minute or so. I am well equipped to debug such problems. Besides, 
this is FC. 
Once upon a time I've seen some ugly low-level incompatibility in FC 
too - that resulted in some really nice messages from the Linux 
kernel. 
I also know a brand of controllers which claim support for TCQ depth 
of 255, but actually hang with anything over 192 or so. This also 
yields a proper error in Linux, and the RAID controller goes toes up. 

None of this happens in my case... all is happy and calm.
Hmm... maybe I should try some modern FreeBSD for comparison :-)))

Apologies for not mentioning specific hardware brands - I don't want 
to get in trouble...

> > Would it be any help if I switched to 64bit mode?
> 
> Yes, it would be worth a try.
> 
:-/ Okay, time to install 64bit Fedora 8 or something :-)

Anyway, thanks very much for your response :-)

Frank Rysanek

