Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYICRG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYICRG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYICRGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:06:51 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47597 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbYICRGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:06:50 -0400
Date: Wed, 3 Sep 2008 13:06:49 -0400
To: linux-kernel@vger.kernel.org
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: How to add the Asus R1F to asus-laptop.c?
Message-ID: <20080903170649.GF12476@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My wife has an Asu R1F and I have been trying to help her get wireless
networking to work on it.

The chipset is an intel 3945abg, so that part should be simple, and the
driver does in fact load and see things.  unfortunately the radio is
killed and there is no hardware switch to toggling it.  Instead you have
to use fn-F2 as on many other Asus laptops.

I have managed to manually toggle it and see the Ap by poking at values
exported by asus-acpi in /proc and /sys, but that isn't very convinient.

It would appear that the asus-laptop driver is supposed to manage
hotkeys on many asus laptops, but unfortunately the R1F isn't recognized
by the driver, which refuses to load.

Looking at the sourceforge.net page mentioned in asus-laptop.c as the
development site, I see that there is in fact a patch submitted for the
R1F (which is almost the same as the M2E) to that site in may 2007, but
apparently no one monitors that site anymore, and it never got submitted
to the kernel.

Who needs to be poked to have anything like that happen?  Why is that
site listed in the driver anymore, if it isn't being used now?

If I test out the patch and it works, should I submit it here to have it
included so that this can be solved once and for all?

-- 
Len Sorensen
