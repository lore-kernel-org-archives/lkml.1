Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbXJXVhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbXJXVhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760076AbXJXVhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:37:36 -0400
Received: from beast.tiendalinux.com ([65.99.217.191]:56883 "EHLO
	beast.tiendalinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbXJXVhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:37:35 -0400
X-SMTP-Auth: no
Message-ID: <471FBB1B.8010000@tiendalinux.com>
Date: Wed, 24 Oct 2007 16:37:31 -0500
From: "Nestor A. Diaz" <nestor@tiendalinux.com>
Organization: TiendaLinux.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: RAID 10 w AHCI w NCQ = Spurius  I/O error
References: <471FA857.8060702@tiendalinux.com> <20071024205212.GO4003@csclub.uwaterloo.ca>
In-Reply-To: <20071024205212.GO4003@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Len, thenks for your answer, i need a clarification on wheter it
could be a software or a hardware problem, fortunatelly i have an exact
system, so what i am going to do is to swap the four drives on the first
system to the second system, and with more time i will make the required
tests.

p.d. the machine is debian 4.0 amd64 system.


Lennart Sorensen wrote:
> It seems to me that if the kernel says there is an io error explicitly 
> on sdd, then I don't think it really should be any fault with the raid
> setup.  My assumption would be that there is a flacky drive, a flacky
> cable, or maybe a flacky port on the controller.
>   
I change the drive and the problem remains, i will check changing the
hard drive cables, to see if that is the problem, the problem has
apperead three times in nearly five months, so what will be your bet ?
> It would be interesting to know what happened if you swapped the cables
> between sdd and another drive to see if the problem follows the port or
> the drive or the cable (you could move sdd's cable to sda, and then
> connect sdd to sdc's port and sdc to sdd's port, and if sda then fails,
> it should be the cable, if sdd (was sdc) fails, then it must be the
> port, and if sdc (was sdd) fails then it must be the drive.  At least
> that is what I think.  the raid should deal with moving the drives
> around just fine since it should be using the UUIDs for assembly anyhow.
>
> --
> Len Sorensen
>   


-- 
Nestor A. Diaz
Ingeniero de Sistemas
Tel. +57 1-600-5490 x 211
Cel. +57 316-227-3593
Tel. SIP: sip:211@tiendalinux.com
Email/MSN: nestor@tiendalinux.com
http://www.tiendalinux.com/
Bogota, Colombia


