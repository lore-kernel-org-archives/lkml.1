Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYKWJ5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYKWJ5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYKWJ5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:57:34 -0500
Received: from inhex.net ([193.33.178.145]:46596 "EHLO inhex.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYKWJ5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:57:33 -0500
Date: Sun, 23 Nov 2008 11:57:08 +0200
From: Dmitry Nezhevenko <dion@inhex.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.28 git: WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404
	generic_get_mtrr+0xea/0x120()
Message-ID: <20081123095708.GA7502@laptop.local>
References: <20081120092239.GA16613@laptop.local> <200811222144.31812.rjw@sisk.pl> <86802c440811221343n61b9d20cue4d89c1c4b45121c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440811221343n61b9d20cue4d89c1c4b45121c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 01:43:25PM -0800, Yinghai Lu wrote:
> 
> can we get whole boot message? also cat /proc/mtrr
> 
> YH

dmesg: http://inhex.net/dion/tmp/dmesg-2.6.28-rc5.txt

/proc/mtrr:
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg04: base=0x0000f8000 (    0MB), size=   32KB, count=1: write-protect
reg05: base=0x0000dc000 (    0MB), size=    8KB, count=1: write-back

Same message exists in 2.6.27 dmesg:
mtrr: your BIOS has set up an incorrect mask, fixing it up.

However it isn't warning.
 
-- 
WBR, Dmitry
