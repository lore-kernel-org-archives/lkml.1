Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbXLVX7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbXLVX7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 18:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXLVX7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 18:59:33 -0500
Received: from waste.org ([66.93.16.53]:38399 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbXLVX7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 18:59:33 -0500
Subject: ACPI or radeon: spontaneous reboot regression
From: Matt Mackall <mpm@selenic.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: linux-acpi@vger.kernel.org, benh@kernel.crashing.org, rjw@sisk.pl
Content-Type: text/plain
Date: Sat, 22 Dec 2007 17:58:56 -0600
Message-Id: <1198367937.8260.6.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.24-rc2, plugging and unplugging power results in a sudden
reboot. After the reboot, the machine boots normally until it switches
to graphics mode, at which point the screen is scrambled. It may hang or
repeatedly reboot at this point. Easily repeatable after just a few plug
cycles.

Switching back to 2.6.23-rc3-mm1, I can do a dozen plug cycles with no
problem.

Machine is a Thinkpad R51, with R250:

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R250
[Mobility FireGL 9000] (rev 02)

(starting bisection)

-- 
Mathematics is the supreme nostalgia of our time.

