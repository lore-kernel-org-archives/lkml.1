Return-Path: <linux-kernel-owner+w=401wt.eu-S1759807AbXFOXaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807AbXFOXaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbXFOXad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:30:33 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:54707 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757493AbXFOXac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:30:32 -0400
Message-ID: <4673212B.5010304@cfl.rr.com>
Date: Fri, 15 Jun 2007 19:30:51 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "R.F. Burns" <burnsrf@gmail.com>, Lee Revell <rlrevell@joe-job.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PC speaker
References: <a800cda90706120545w2c6d0bb0vb77bd4d961415c5c@mail.gmail.com> <75b66ecd0706120744g7cdb3392l6537b5c68c2d6b21@mail.gmail.com> <a800cda90706121325p18c85b00r7bc4b15b95517371@mail.gmail.com> <4672C76D.5050008@cfl.rr.com> <Pine.LNX.4.64.0706152131450.32724@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706152131450.32724@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2007 23:30:49.0319 (UTC) FILETIME=[34C5C770:01C7AFA5]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15240.001
X-TM-AS-Result: No--4.143400-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 15 2007 13:07, Phillip Susi wrote:
>> R.F. Burns wrote:
>>> However, over the past several weeks, the students have found more
>>> creative ways to abuse the PC speaker (outside of the OS.)  The Powers
>>> that Be are asking that the PC speakers be disabled completely.  With
>>> the small number of techs we have, it would be very impractical to go
>>> around to all systems and remove the PC speaker from each and every
>>> computer case.
>> Now I am curious; how are they getting the pc speaker to make any sound with
>> the kernel module disabled?
> 
> ioperm(), inb(), and outb() from userspace. Needs root, though. Or 
> /dev/port, with write. Which comes to the question how they gained root. 
> Perhaps live cd? In which case, the OP should, as recommended in this 
> thread already, deactivate choosing boot devices, if that's possible.
> 
> (Unfortunately, newer BIOSes with 'integrated bootmenu' with F8 or so, 
> but I have not seen a way to deactivate _that_ menu.)

He already said they don't have root access and that allowed him to stop 
them from accessing the sound card by setting appropriate permissions.

