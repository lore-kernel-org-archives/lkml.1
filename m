Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbXGOTqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbXGOTqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbXGOTq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:46:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:15450 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbXGOTq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:46:28 -0400
Date: Sun, 15 Jul 2007 21:46:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: linux-fsdevel@vger.kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: *at syscalls for xattrs?
Message-ID: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


recently, the family of *at() syscalls and functions (openat, fstatat, 
etc.) have been added to Linux and Glibc, respectively.
In short: I am missing xattr at functions :)

BTW, why is fstatat called fstatat and not statat? (Same goes for 
futimesat.) It does not take a file descriptor for the file argument. 
Otherwise we'd also need fopenat/funlinkat, etc. Any reasons?


Thanks,
	Jan
-- 
