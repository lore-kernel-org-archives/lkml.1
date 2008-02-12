Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbYBLXfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbYBLXfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYBLXf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:35:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59001
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752900AbYBLXfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:35:25 -0500
Date: Tue, 12 Feb 2008 15:35:57 -0800 (PST)
Message-Id: <20080212.153557.159395336.davem@davemloft.net>
To: chris.mason@oracle.com
Cc: jengelh@computergmbh.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802120935.20437.chris.mason@oracle.com>
References: <200802120908.59602.chris.mason@oracle.com>
	<Pine.LNX.4.64.0802121518500.21102@fbirervta.pbzchgretzou.qr>
	<200802120935.20437.chris.mason@oracle.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Mason <chris.mason@oracle.com>
Date: Tue, 12 Feb 2008 09:35:20 -0500

> From my point of view, 0 is a bad idea because it is very likely to
> conflict with other things.

Starting at 0 is a bad idea because otherwise you'll waste
significant chunks of your disk on Sparc because of reasons
I've outlined in other replies.

What XFS does is really unfortunate, let's learn from it's
mistake.
