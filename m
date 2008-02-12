Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYBLXdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYBLXdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYBLXc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:32:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58992
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbYBLXc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:32:57 -0500
Date: Tue, 12 Feb 2008 15:33:29 -0800 (PST)
Message-Id: <20080212.153329.98384016.davem@davemloft.net>
To: chris.mason@oracle.com
Cc: jengelh@computergmbh.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802120908.59602.chris.mason@oracle.com>
References: <200802120849.34477.chris.mason@oracle.com>
	<Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
	<200802120908.59602.chris.mason@oracle.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Mason <chris.mason@oracle.com>
Date: Tue, 12 Feb 2008 09:08:59 -0500

> I've had requests to move the super down to 64k to make room for
> bootloaders, which may not matter for sparc, but I don't really plan
> on different locations for different arches.

The Sun disk label sits in the first 512 bytes and the boot loader
block sits in the second 512 bytes.

I think leaving even more space is a good idea for several reasons.
