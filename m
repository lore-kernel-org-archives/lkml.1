Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbZAPMz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbZAPMz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZAPMzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:55:21 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51003 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZAPMzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:55:20 -0500
Date: Fri, 16 Jan 2009 13:55:18 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: sam@ravnborg.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: include2/asm -> asm-x86 dangling link
Message-ID: <alpine.LSU.2.00.0901161351110.2957@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


since the include/asm-x86 directory is gone, the include2/asm symlink 
that is generated in O= builds points to a non-existing directory, which 
the SUSE rpm scripts flagged up whilst trying to package it.
This affects at least 2.6.29-rc1.

~/Coding_nosov/linux > l ../linux-obj/include2/
total 4
drwxr-xr-x  2 jengelh users   16 Jan 12 01:08 .
drwxr-xr-x 21 jengelh users 4096 Jan 16 13:47 ..
lrwxrwxrwx  1 jengelh users   48 Jan 12 01:08 asm -> /home/jengelh/Coding_nosov/linux/include/asm-x86

I'd appreciate if this could be addressed in a future release.


thanks,
Jan
