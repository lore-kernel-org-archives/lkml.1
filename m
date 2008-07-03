Return-Path: <linux-kernel-owner+w=401wt.eu-S936098AbYGCHNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936098AbYGCHNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbYGCG6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:41 -0400
Received: from smtp-out-4.talktalk.net ([62.24.128.234]:6933 "EHLO
	smtp.talktalk.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755222AbYGCGRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 02:17:22 -0400
X-Path: TTSMTP
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtItAPkLbEhZ8m2EPGdsb2JhbACIQIl6AQEBAS2fHg
Date: Thu, 3 Jul 2008 07:17:16 +0100 (BST)
From: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
X-X-Sender: tigran@ginsburg.homenet
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New World
 Order firmware...
In-Reply-To: <4534.1215048758@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
References: <4534.1215048758@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis,

On Wed, 2 Jul 2008 Valdis.Kletnieks@vt.edu wrote:

> I built the -rc8-mmotd kernel, and built it with 'CONFIG_FIRMWARE_IN_KERNEL=n'.
> Lo and behold, the microcode.ko was now doing a request_firmware for
> 'intel-ucode/06-0f-06' (which makes sense, the Core2 Duo in this laptop is
> family 6, model 15, stepping 6).  However, what I had in /lib/firmware was
> the Intel-distributed 'microcode.dat' with updates for all the CPUs (which
> used to work in times past).
>
> What's the magic incantation to take the microcode.dat and create something
> that the firmware driver is willing to use, or is this all borked up and
> I need to do a major rethink or fix my config?

that's because it expects the Intel-supplied microcode data and you are 
using the old style microcode.dat data.

Kind regards
Tigran

>
> Another minor annoyance - the tg3 driver, when builtin to the kernel, wouldn't
> load the microcode in this config. It complained it couldn't get 'tigon/tg3_tos.bin',
> but that's almost certainly an issue with Fedora's 'nash' firmware support and/or
> my understanding of it - I got *that* part working by dropping the file into
> /lib/firmware/tigon and building the driver as a module. Fortunately, I don't
> need the tg3 driver to boot far enough to get a full udev running.
>
>
