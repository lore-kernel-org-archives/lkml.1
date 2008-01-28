Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYA1IqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYA1IqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYA1Ip7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:45:59 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:38239 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbYA1Ip6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:45:58 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2008 08:45:40 +0000
Message-Id: <1201509949-3285-1-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Unify arch/x86/boot/compressed/{vmlinux.scr,misc.c}
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes from last time:
  * Use .rodata.compressed instead of .data.compressed.
  * Use the 64 bit strings rather than the 32 bit versions, dropping the
    odd leading "."

