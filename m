Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbYI3MaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbYI3MaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYI3MaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:30:06 -0400
Received: from main.gmane.org ([80.91.229.2]:56483 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbYI3MaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:30:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Michael Fritscher <michael@fritscher.net>
Subject: Linux 2.6.27-rc8 - e1000 problems: bug(s) report
Date: Tue, 30 Sep 2008 12:26:27 +0000 (UTC)
Message-ID: <loom.20080930T122142-798@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 132.187.61.49 (Mozilla/5.0 (X11; U; Linux i686; de; rv:1.8.1.16) Gecko/20080716 SUSE/2.0.0.16-0.4 Firefox/2.0.0.16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
at first: no, I didn't brick my thinkpad x61 :-)

But: I have severe problems since 2.6.26 (jes) kernel: textmode consoles doesn't
work most(!) of the time, sometimes the notebook crashes on boot, displaying
garbage. The 2.6.24/xen kernel from ubuntu doesn't work with X, too.
Suspend/resume doesn't work anymore with the 2.6.26/27 kernel, too (garbage on
display)
Its a x3100 chipset with 4GB ram, I don't use a highmem-kernel, so I've only 3
GB. Perhaps something with mem sharing between kernel/X/chipset?
Ah, and the pen doesn't work most of the time, with wacdump I get many bit
errors. The resolution is 1400x1050, sometimes I boot into Vista.

I'm using ubuntu 8.10.

Hopefully this informations help to get a more complete puzzle. Even more
information are on my bug reports, https://bugs.launchpad.net/~michael-fritscher
Perhaps most of them are connected each other and to this e1000 problem, like
memory layout mismatch between kernel/X/chipset.

Sincerly,
Michaek Fritscher

