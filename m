Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbXGIN3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbXGIN3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757013AbXGIN3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:29:21 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:60797 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946AbXGIN3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:29:19 -0400
Date: Mon, 9 Jul 2007 14:21:22 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@HansenPartnership.com, ak@suse.de,
       linux-mips@linux-mips.org, discuss@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] cpu_callout_map cleanups
Message-ID: <20070709132122.GA10931@linux-mips.org>
References: <20070707010327.GX3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070707010327.GX3492@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 03:03:27AM +0200, Adrian Bunk wrote:

> - mips: removed extern for non-existing variable from header

There also is

include/linux/smp.h:#define num_booting_cpus()                  1

but num_booting_cpus() is only ever being used in i386-specific code.

I'm going to merge the MIPS bits of your patch.

  Ralf
