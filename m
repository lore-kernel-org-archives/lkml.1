Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbYBGHYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbYBGHYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbYBGHYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:24:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39507
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754598AbYBGHYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:24:20 -0500
Date: Wed, 06 Feb 2008 23:24:51 -0800 (PST)
Message-Id: <20080206.232451.146394908.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080207072030.GA24242@suse.de>
References: <20080207070044.GA4851@suse.de>
	<20080206.231144.174648341.davem@davemloft.net>
	<20080207072030.GA24242@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Wed, 6 Feb 2008 23:20:30 -0800

> It's odd that the original one didn't also do that,

In the old code it would vector through part_sysfs_ops (look at how it
works before the changeset), which returns 0 if the attribute lacked a
->show method.

