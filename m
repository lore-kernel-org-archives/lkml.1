Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbZFMWy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbZFMWy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbZFMWyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:54:21 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:34428 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751627AbZFMWyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:54:21 -0400
Message-ID: <4A342E1F.60607@pardus.org.tr>
Date: Sun, 14 Jun 2009 01:54:23 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
References: <20090613230842.GA18347@gallifrey>
In-Reply-To: <20090613230842.GA18347@gallifrey>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dr. David Alan Gilbert wrote:
> Hi,
>   I've got an old Pentium 90 machine that's been running a 2.4.x
> kernel for a long time, seems to work OK on a 2.6.18 kernel
> but doesn't seem to like anything newer.
>
> 2.6.30 no keyboard - but otherwise OK
> 2.6.28 no keyboard - but otherwise OK
> 2.6.26 reboots just after parsing ELF (maybe one more line)
> 2.6.25 reboots almost immediately
> 2.6.18 works OK
>   

I'm having that weird problem on one of my computers too, I've reported
it here but then I started to blame my mainboard and BIOS because I
can't even boot into 2.6.25 which I was using months ago without an
issue. My keyboard stops working just after the parport* modules are
plugged. I really wonder what will happen if you blacklist lp, ppdev,
parport and parport_pc modules.

Thanks,
