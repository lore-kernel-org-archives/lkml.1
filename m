Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYGCHBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYGCHBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYGCG5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbYGCBsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:48:21 -0400
Date: Wed, 2 Jul 2008 18:43:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New
 World Order firmware...
Message-Id: <20080702184315.f659ec92.akpm@linux-foundation.org>
In-Reply-To: <4534.1215048758@turing-police.cc.vt.edu>
References: <4534.1215048758@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008 21:32:38 -0400 Valdis.Kletnieks@vt.edu wrote:

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
> 
> Another minor annoyance - the tg3 driver, when builtin to the kernel, wouldn't
> load the microcode in this config. It complained it couldn't get 'tigon/tg3_tos.bin',
> but that's almost certainly an issue with Fedora's 'nash' firmware support and/or
> my understanding of it - I got *that* part working by dropping the file into
> /lib/firmware/tigon and building the driver as a module. Fortunately, I don't
> need the tg3 driver to boot far enough to get a full udev running.
> 

(cc dwmw2)
