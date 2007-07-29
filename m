Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbXG2QrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbXG2QrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764084AbXG2QrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:47:16 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:36132 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762366AbXG2QrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:47:15 -0400
Subject: Re: [PATCH] drivers/bluetooth/hci_ldisc.c: fix possible NULL
	dereferences
From: Marcel Holtmann <marcel@holtmann.org>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070729144736.GA13275@kernel.sg>
References: <20070729144736.GA13275@kernel.sg>
Content-Type: text/plain
Date: Sun, 29 Jul 2007 18:49:11 +0200
Message-Id: <1185727751.5868.60.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eugene,

> Commit 22ad42033b7d2b3d7928fba9f89d1c7f8a3c9581 did not completely fix all 
> the possible NULL dereferences. Besides hci_uart_close(), we also need to 
> make sure that hdev is valid before calling hci_{unregister,free}_dev().

I don't see any issue. Without HCI_UART_PROTO_SET, the hdev will never
be registered. So no need to protect it twice.

Regards

Marcel


