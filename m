Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZAMFGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZAMFGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbZAMFGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:06:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60751 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZAMFGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:06:06 -0500
Date: Mon, 12 Jan 2009 21:05:01 -0800 (PST)
Message-Id: <20090112.210501.215941396.davem@redhat.com>
To: linux-kernel@vger.kernel.org
CC: sparclinux@vger.kernel.org, balajirrao@openmoko.org, andy@openmoko.com,
       sameo@openedhand.com, mingo@elte.hu, yinghai@kernel.org,
       akpm@linux-foundation.org, sfr@canb.auug.org.au
Subject: pcf50663 MFD driver modular build failure
From: David Miller <davem@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This started happening with Linus's pull from today for
sparc64 allmodconfig:

ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!

Sure we can export __set_irq_handler() and handle_level_irq() to
modules to fix this, but that looks like some hokey stuff for
a MFD driver to be doing :-)
