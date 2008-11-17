Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYKQP7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYKQP7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYKQP7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:59:41 -0500
Received: from main.gmane.org ([80.91.229.2]:58768 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYKQP7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:59:40 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: [2.6.27] drm errors with intel GM965
Date: Mon, 17 Nov 2008 15:57:54 +0000
Message-ID: <gfs4ct$tgt$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 83-70-247-105-dynamic.b-ras1.prp.dublin.eircom.net
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get the following errors with kernel 2.6.27.6 using GM965 graphics
controller. Redrawing windows under X can be very slow compared e.g. a few
months ago. Not sure if this is a kernel problem or a problem with X? Both
have been upgraded since then.

[   58.250828] [drm] Initialized drm 1.1.0 20060810
[   58.298064] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   58.298094] pci 0000:00:02.0: setting latency timer to 64
[   58.298604] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   58.300601] [drm:i915_getparam] *ERROR* Unknown parameter 5
[   59.978000] X:7524 conflicting memory types e0000000-f0000000
write-combining<->uncached-minus
[   59.978024] reserve_memtype failed 0xe0000000-0xf0000000, track
write-combining, req write-combining
[   60.700983] X:7524 conflicting memory types e0000000-f0000000
write-combining<->uncached-minus
[   60.701010] reserve_memtype failed 0xe0000000-0xf0000000, track
write-combining, req write-combining
[   60.717610] X:8228 freeing invalid memtype e0000000-f0000000
[   82.161713] X:7524 conflicting memory types e0000000-f0000000
write-combining<->uncached-minus
[   82.161742] reserve_memtype failed 0xe0000000-0xf0000000, track
write-combining, req write-combining
[   82.179838] X:8724 freeing invalid memtype e0000000-f0000000

Marcus.

