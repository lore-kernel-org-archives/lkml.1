Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYF1ErT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYF1ErT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 00:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYF1ErG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 00:47:06 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:23237 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751950AbYF1ErD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 00:47:03 -0400
Date: Sat, 28 Jun 2008 13:43:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 24/60] microblaze_v4: asm-offsets
Message-ID: <20080628044358.GE25492@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, monstr@seznam.cz,
	linux-kernel@vger.kernel.org, arnd@arndb.de,
	linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
	John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
	will.newton@gmail.com, drepper@redhat.com,
	microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
	linuxppc-dev@ozlabs.org, vapier.adi@gmail.com,
	alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
	Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-16-git-send-email-monstr@seznam.cz> <1214483429-32360-17-git-send-email-monstr@seznam.cz> <1214483429-32360-18-git-send-email-monstr@seznam.cz> <1214483429-32360-19-git-send-email-monstr@seznam.cz> <1214483429-32360-20-git-send-email-monstr@seznam.cz> <1214483429-32360-21-git-send-email-monstr@seznam.cz> <1214483429-32360-22-git-send-email-monstr@seznam.cz> <1214483429-32360-23-git-send-email-monstr@seznam.cz> <1214483429-32360-24-git-send-email-monstr@seznam.cz> <1214483429-32360-25-git-send-email-monstr@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214483429-32360-25-git-send-email-monstr@seznam.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:29:53PM +0200, monstr@seznam.cz wrote:
> +#include <linux/stddef.h>
> +#include <linux/sched.h>
> +#include <linux/kernel_stat.h>
> +#include <linux/ptrace.h>
> +#include <linux/hardirq.h>
> +#include <linux/thread_info.h>
> +
> +#define DEFINE(sym, val) asm volatile("\n->" #sym " %0 " #val : : "i" (val))
> +#define BLANK() asm volatile("\n->" : :)
> +
There are generic definitions for these these days, include linux/kbuild.h.
