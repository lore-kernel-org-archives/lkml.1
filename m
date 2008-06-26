Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbYFZSVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbYFZSVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756688AbYFZSVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:21:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbYFZSVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:21:22 -0400
Message-ID: <4863CB8A.7000204@zytor.com>
Date: Thu, 26 Jun 2008 10:02:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: monstr@seznam.cz, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 59/60] microblaze_v4: syscall_table.S and unistd.h
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-59-git-send-email-monstr@seznam.cz> <1214483429-32360-60-git-send-email-monstr@seznam.cz> <200806261831.19187.arnd@arndb.de>
In-Reply-To: <200806261831.19187.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> You still set __NR_fork. There is no point defining the number if you
> can't actually call the syscall in the first place.
> 

Worse, it is actively *harmful* to set the number; klibc or anything 
that uses similar kinds of scripts for portability will see the symbol 
and think the system call is available.

	-hpa
