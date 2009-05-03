Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbZECJFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbZECJFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZECJFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:05:31 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:45427 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZECJFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:05:30 -0400
Date: Sun, 3 May 2009 11:05:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Anders Kaseorg <andersk@mit.edu>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Lots of unexpected non-allocatable section warnings
Message-ID: <20090503110517.6d09bca2@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anders, Sam,

After your fix "kbuild, modpost: Check the section flags, to catch
missing ax/aw", I get a lot of warnings like the following during
modpost on x86-64:

WARNING: arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.o (.comment.SUSE.OPTs): unexpected non-allocatable section.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

Apparently there's one such warning for every module on my system, that
is, 907. That's a lot, and pretty annoying. How do I solve this? I don't
know much about assembly.

Thanks,
-- 
Jean Delvare
