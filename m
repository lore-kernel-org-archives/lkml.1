Return-Path: <linux-kernel-owner+w=401wt.eu-S1764371AbXGaQqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764371AbXGaQqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765373AbXGaQpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:45:53 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2673 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764811AbXGaQpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:45:50 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [KJ PATCHES] mostly kmalloc + memset conversion to k[cz]alloc
Date: Tue, 31 Jul 2007 18:45:48 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200707311845.48807.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This kj patch series does kmalloc + memset conversion to k[cz]alloc. Some
of them also remove redundant argument checks to functions that already do that
internally. Also some minor style things are fixed like redundant k[mcz]alloc casts.
Most of this patches shrink object size by several hundred bytes (you'll find stats
below signed-off line) so this is a good thing. Almost all of them were compile tested.

Please review and apply.

Regards,

	Mariusz
