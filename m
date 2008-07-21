Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbYGUNS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbYGUNS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYGUNSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:18:48 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:44519 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYGUNSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:18:48 -0400
Date: Mon, 21 Jul 2008 15:18:46 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: asm-x86/byteorder.h, CONFIG_X86_BSWAP leaks to userland
Message-ID: <20080721131846.GA28697@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


What is the purpose of CONFIG_X86_BSWAP in asm-x86/byteorder.h?

An undefined CONFIG_foo defaults to 0 (I think), so bswap is never used.
Is this done on purpose, or can the CONFIG_ foo be moved inside
__KERNEL__ somehow?

Olaf
