Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYJNCFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYJNCFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 22:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbYJNCE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 22:04:56 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:38406 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbYJNCEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 22:04:55 -0400
X-Greylist: delayed 1140 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2008 22:04:55 EDT
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200810140145.m9E1jsFF001817@clem.clem-digital.net>
Subject: 27-git2,3,4 panics on boot
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Mon, 13 Oct 2008 21:45:54 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi, x86 pentium III, uniprocessor, panics as soon as
it starts the boot up.  Output scrolls off screen, here is 
the partial call list remaining of screen:

vprintk
klist_next
match_pci_dev_by_id
printk
__reserve_region_with_split
e820_reserve_resources_late
pcibios_init
pci_subsys_init
input_init
pci_subsyst_init
_stext
proc_register
create-proc_entry
register_irq_proc
kernel_init
kernel_init
kernel_thread_helper

2.6.27-git1 booted fine. 
-- 
Pete Clements 

