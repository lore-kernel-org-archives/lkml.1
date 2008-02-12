Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYBLX2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYBLX2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYBLX1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:27:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39664
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbYBLX1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:27:54 -0500
Date: Tue, 12 Feb 2008 15:28:26 -0800 (PST)
Message-Id: <20080212.152826.243855481.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
References: <20080212.001104.172517283.davem@davemloft.net>
	<200802120849.34477.chris.mason@oracle.com>
	<Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Tue, 12 Feb 2008 15:00:20 +0100 (CET)

> Something looks wrong here. Why would btrfs need to zero at all?

So that existing superblocks on the partition won't
be interpreted as correct by other filesystems.  It's
a safety measure many mkfs programs use.

> Superblock at 0, and done. Just like xfs.

No, we won't do stupid things like that and make an entire
cylinder of our disks unusable.  See my other reply.

