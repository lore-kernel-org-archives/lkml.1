Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZB1NDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZB1NDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 08:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZB1NDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 08:03:09 -0500
Received: from thunk.org ([69.25.196.29]:58922 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbZB1NDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 08:03:08 -0500
To: Dave Airlie <airlied@linux.ie>, Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: i915 needs pgprot_writecombine() and is_io_mapping_posible()
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1LdOqH-0004wg-JB@closure.thunk.org>
Date: Sat, 28 Feb 2009 08:02:57 -0500
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent (probably within the last week) commit seems to have caused
the i915 driver to need to use two unexported symbols:

ERROR: "pgprot_writecombine" [drivers/gpu/drm/i915/i915.ko] undefined!
ERROR: "is_io_mapping_possible" [drivers/gpu/drm/i915/i915.ko] undefined!

Is the right fix just to export them?  

Thanks,

							- Ted
