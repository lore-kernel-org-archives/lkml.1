Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZGUKBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZGUKBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbZGUKBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:01:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40877 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbZGUKBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:01:20 -0400
Date: Tue, 21 Jul 2009 12:01:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: apw@canonical.com, kernel list <linux-kernel@vger.kernel.org>
Subject: checkpatch whitespace
Message-ID: <20090721100113.GC4133@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Checkpatch regulary complains about bad whitespace:

pavel@amd:/data/l/linux-msm/drivers/input/touchscreen$
../../../scripts/checkpatch.pl --file synaptics_i2c_rmi.c
ERROR: trailing whitespace
#245: FILE: synaptics_i2c_rmi.c:245:
+^Ipr_info("synaptics: version %x, product property %x\n", $

ERROR: trailing whitespace
#250: FILE: synaptics_i2c_rmi.c:250:
+static void compute_areas(struct synaptics_ts_data *ts,^I$

ERROR: trailing whitespace
#326: FILE: synaptics_i2c_rmi.c:326:
+^I^I^I     -inactive_area_left, max_x + inactive_area_right, $

ERROR: trailing whitespace
#468: FILE: synaptics_i2c_rmi.c:468:
+^I^Ipr_err("synaptics: Unable to register %s input device\n", $

ERROR: trailing whitespace
#497: FILE: synaptics_i2c_rmi.c:497:
+^Ipr_info("synaptics: Start touchscreen %s in %s mode\n", $

total: 5 errors, 0 warnings, 635 lines checked


I don't think that a bit of trailing whitespace hurts that much (it is
very easy to create when fixing overly long lines, another checkpatch
complain), and at least akpm autofixes the whitespace, anyway, but...

Would it be possible to add autofixing to checkpatch? Fixing
whitespace issues by hand is useless & boring task...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
