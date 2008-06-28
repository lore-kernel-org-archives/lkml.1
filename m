Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYF1FN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYF1FN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 01:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYF1FNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 01:13:17 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:40964 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750806AbYF1FNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 01:13:16 -0400
Date: Sat, 28 Jun 2008 14:10:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 59/60] microblaze_v4: syscall_table.S and unistd.h
Message-ID: <20080628051027.GJ25492@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, monstr@seznam.cz,
	linux-kernel@vger.kernel.org, arnd@arndb.de,
	linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
	John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
	will.newton@gmail.com, drepper@redhat.com,
	microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
	linuxppc-dev@ozlabs.org, vapier.adi@gmail.com,
	alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
	Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-51-git-send-email-monstr@seznam.cz> <1214483429-32360-52-git-send-email-monstr@seznam.cz> <1214483429-32360-53-git-send-email-monstr@seznam.cz> <1214483429-32360-54-git-send-email-monstr@seznam.cz> <1214483429-32360-55-git-send-email-monstr@seznam.cz> <1214483429-32360-56-git-send-email-monstr@seznam.cz> <1214483429-32360-57-git-send-email-monstr@seznam.cz> <1214483429-32360-58-git-send-email-monstr@seznam.cz> <1214483429-32360-59-git-send-email-monstr@seznam.cz> <1214483429-32360-60-git-send-email-monstr@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214483429-32360-60-git-send-email-monstr@seznam.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:30:28PM +0200, monstr@seznam.cz wrote:
> +#define __NR_semtimedop		325
> +#define __NR_timerfd_settime	326
> +#define __NR_timerfd_gettime	327
> +
> +#ifdef __KERNEL__
> +
> +#define __NR_syscalls		327
> +
Off-by-1 on __NR_syscalls, this should be 328.
