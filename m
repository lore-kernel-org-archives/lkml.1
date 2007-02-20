Return-Path: <linux-kernel-owner+w=401wt.eu-S965783AbXBTApl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965783AbXBTApl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965780AbXBTApl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:45:41 -0500
Received: from holomorphy.com ([66.93.40.71]:56933 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965783AbXBTApk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:45:40 -0500
Date: Mon, 19 Feb 2007 16:42:18 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: ak@suse.de, discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: x86_64: up to 255 or 256 CPUs?
Message-ID: <20070220004218.GO21484@holomorphy.com>
References: <20070220000647.GI13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220000647.GI13958@stusta.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 01:06:47AM +0100, Adrian Bunk wrote:
> Quoting arch/x86_64/Kconfig:
> <--  snip  -->
> ...
> config NR_CPUS
>         int "Maximum number of CPUs (2-256)"
>         range 2 255
> ...
> <--  snip  -->
> cu
> Adrian

The broadcast APIC ID clashes with the 256th cpu.


-- wli
