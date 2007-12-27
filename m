Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbXL0DFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbXL0DFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 22:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbXL0DFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 22:05:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51037
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751870AbXL0DFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 22:05:05 -0500
Date: Wed, 26 Dec 2007 19:05:04 -0800 (PST)
Message-Id: <20071226.190504.20990618.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: some section mismatches on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712261329.08313.m.kozlowski@tuxland.pl>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	<200712261329.08313.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Wed, 26 Dec 2007 13:29:07 +0100

> WARNING: vmlinux.o(.text+0x46b04): Section mismatch: reference to .init.text:sun4v_ktsb_register (between 'smp_callin' and 'smp_fill_in_sib_core_maps')

Well known and I see them every build and so does everyone
else on sparc64.

They are harmless and as time allows I try to find ways
to get rid of them but it's very low priority.
