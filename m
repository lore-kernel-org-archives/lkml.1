Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbXLRWao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbXLRWao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXLRWac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:30:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50384
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752151AbXLRWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:30:30 -0500
Date: Tue, 18 Dec 2007 14:30:26 -0800 (PST)
Message-Id: <20071218.143026.78772130.davem@davemloft.net>
To: stefanr@s5r6.in-berlin.de
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       krh@bitplanet.net, linux1394-devel@lists.sourceforge.net
Subject: Re: No dma_sync_* during pci_probe? (Sparc, post 2.6.22 regression)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4767A323.7090205@s5r6.in-berlin.de>
References: <47670BDF.80409@s5r6.in-berlin.de>
	<20071217.165032.41424988.davem@davemloft.net>
	<4767A323.7090205@s5r6.in-berlin.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Tue, 18 Dec 2007 11:38:27 +0100

>   - There has been no other report of this kind for any other
>     architecture yet.  I would expect e.g. the PPC64 folks to report
>     bugs in our dma mappings eventually.

Irrelevant fact, powerpc handles it's dev_archdata differently
from sparc64.
