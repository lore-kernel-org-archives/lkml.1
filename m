Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbXICQX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbXICQX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 12:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbXICQXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 12:23:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60590 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXICQXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 12:23:19 -0400
Date: Mon, 3 Sep 2007 18:23:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Mounts and namespaces
Message-ID: <Pine.LNX.4.64.0709031821040.24179@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


what happens to mounts when the namespace they exist in, exits?
In my concrete case:

	./newns /bin/bash
	# clone(CLONE_NEWNS | CLONE_THREAD | CLONE_SIGHAND | CLONE_VM)
	# and exec to given program
	mount /dev/loop0 /mnt
	exit

Still mounted and unreachable forever? Forced unmount and fs corruption?


	Jan
-- 
