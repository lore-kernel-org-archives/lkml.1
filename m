Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYJ1SmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYJ1SmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYJ1Sl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:41:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43232
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbYJ1Sl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:41:58 -0400
Date: Tue, 28 Oct 2008 11:41:35 -0700 (PDT)
Message-Id: <20081028.114135.169795007.davem@davemloft.net>
To: avorontsov@ru.mvista.com
Cc: grant.likely@secretlab.ca, david-b@pacbell.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] of/of_i2c: add support for dedicated OF I2C devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081028174615.GC25349@oksana.dev.rtsoft.ru>
References: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
	<20081028174615.GC25349@oksana.dev.rtsoft.ru>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <avorontsov@ru.mvista.com>
Date: Tue, 28 Oct 2008 20:46:15 +0300

> of_i2c will create the OF platform device if it knows that the
> device won't work without platform data. The OF platform driver
> will fill the platform data and will register real I2C device.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Wrt. the comment in the ppc protected code, sparc doesn't need stuff
like this, we already create an of_device for every node in the device
tree.

Just use "of_find_device_by_node()" on sparc, which will work on any
device_node object.
