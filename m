Return-Path: <linux-kernel-owner+w=401wt.eu-S1764007AbXJEUxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764007AbXJEUxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761666AbXJEUxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:53:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39368
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760724AbXJEUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:53:38 -0400
Date: Fri, 05 Oct 2007 13:53:37 -0700 (PDT)
Message-Id: <20071005.135337.74737230.davem@davemloft.net>
To: max@stro.at
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: e1000e oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071005131115.GA31453@stro.at>
References: <20071005131115.GA31453@stro.at>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: maximilian attems <max@stro.at>
Date: Fri, 5 Oct 2007 15:11:15 +0200

> net eth1: device_rename: sysfs_create_symlink failed (-17)
 ...
> no idea if aboves belongs to netdev or sysfs dep.

I think the report belongs to udev.

It tries to rename network devices even if they already
have the name it desires.
