Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbXBDQQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbXBDQQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 11:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXBDQQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 11:16:35 -0500
Received: from yuma.hostsharing.net ([212.42.230.35]:52444 "EHLO
	yuma.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXBDQQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 11:16:34 -0500
Date: Sun, 4 Feb 2007 17:15:21 +0100
From: Elimar Riesebieter <riesebie@lxtec.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [Linux-fbdev-devel] radeonfb: Can't use the dvi port
Message-ID: <20070204161521.GA9623@frodo.home.lxtec.de>
Reply-To: linux-fbdev-devel@lists.sourceforge.net
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13-muttng (2007-01-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I replaced my old monitor with a brandnew LCD one (Samsung
SyncMaster 204B). Booting 2.6.(19|20-rc7) aknowledge the dvi port
but after a while the screen is blank. The monitor claims:

"Not Optimum Mode, Recommended mode : 1600 X 1200 60 Hz"

$ fbset

mode "1600x1200-60"
    # D: 162.022 MHz, H: 75.010 kHz, V: 60.008 Hz
    geometry 1600 1200 1600 1200 8
    timings 6172 304 64 46 1 192 3
    hsync high
    vsync high
    rgba 8/0,8/0,8/0,0/0
endmode


I`ve compiled raeonfb debug in the kernel:
Dec 26 14:52:05 frodo kernel: hStart = 1664, hEnd = 1856, hTotal = 2160
Dec 26 14:52:05 frodo kernel: vStart = 1201, vEnd = 1204, vTotal = 1250
Dec 26 14:52:05 frodo kernel: h_total_disp = 0xc7010d hsync_strt_wid = 0x18067a
Dec 26 14:52:05 frodo kernel: v_total_disp = 0x4af04e1 vsync_strt_wid = 0x304b0
Dec 26 14:52:05 frodo kernel: pixclock = 6172
Dec 26 14:52:05 frodo kernel: freq = 16202
Dec 26 14:52:05 frodo kernel: freq = 16202, PLL min = 20000, PLL max = 40000
Dec 26 14:52:05 frodo kernel: ref_div = 12, ref_clk = 2700, output_freq = 32404
Dec 26 14:52:05 frodo kernel: ref_div = 12, ref_clk = 2700, output_freq = 32404
Dec 26 14:52:05 frodo kernel: post div = 0x1
Dec 26 14:52:05 frodo kernel: fb_div = 0x90
Dec 26 14:52:05 frodo kernel: ppll_div_3 = 0x10090

My card:
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV250 If [Radeon 9000] (rev 01)

Switching to the analog port works well.

Any hints?

Elimar


-- 
  You cannot propel yourself forward by
  patting yourself on the back.
