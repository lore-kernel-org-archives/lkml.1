Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbXJAKYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbXJAKYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXJAKYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:24:30 -0400
Received: from mx1.caravan.ru ([217.23.130.2]:63122 "EHLO mx1.caravan.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXJAKY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:24:29 -0400
Message-ID: <4700CB54.7000206@lxnt.info>
Date: Mon, 01 Oct 2007 14:26:28 +0400
From: Alexander Sabourenkov <screwdriver@lxnt.info>
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Clemens Koller <clemens.koller@anagramm.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Promise SATA300 TX4: errors, oops in ext3 code
References: <47009BF6.5000208@lxnt.info> <4700B966.1030508@anagramm.de>
In-Reply-To: <4700B966.1030508@anagramm.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Koller wrote:
> Alexander Sabourenkov schrieb:
>  > Hardware:  Athlon64, Asus A8V, Promise SATA300 TX4, 2xSeagate 7200.10
>  > 320G, jumper-limited to SATA150.
>  > Kernel : 2.6.22.9 amd64
>  >
>  > Problem:
>  > Heavy load causes errors and triggers oops.
> 
> Have you checked your memory already (memtest86)?

Last run was about a year ago.

This box gets regularly updated (rebuild of all installed software),
so I'm reasonably certain that memory is ok - gcc being almost as 
sensitive as memtest.

Will recheck anyway.

> 
> We have several applications with Promise controllers on strange
> hardware and we never had integrity problems with i.e. not so standard
> SATA connections over custom vaccum-tight connectors.

Judging from linux and freebsd mailing lists, the TX4 is now quite 
well-known for
intermittent problems, which are hard to reproduce on different hardware.

I have two machines with those controllers, one FreeBSD-6.2 on MSI 
K8Neo2 motherboard (ATI chipset),
  and this one. FreeBSD box does not exhibit this problem under the 
little load it gets, but
6-STABLE and 7-CURRENT branches do have similar symptoms since around 19 
April 2007,
with rare occurences (but not unheard of) before.

Thus I am unable to keep machines up to date, and before having to dump 
$140 worth of hardware,
I'd like to try to help fix this problem or at least be certain that 
those controllers are indeed unusable.


>  > Problems were blamed:
>  >   - SATA300 being too 'hot'  (jumpered the drives)
> 
> Is this a common known problem with your harddrives or controller?
> (ask google) Otherwise, it sounds like a problem with broken hardware.

This is a common problem with at least VIA onboard controllers and 
Seagate disks,
and I think with SATA150 controllers and speed negotiation in general.

This step was suggested in some mailing list as a general precaution, but
actually made no difference to error rate.

I did not unjumper drivers back to SATA300 so that I can easily connect 
the drives
to the onboard controller.

-- 

./lxnt


