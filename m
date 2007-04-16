Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbXDPFGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbXDPFGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 01:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXDPFGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 01:06:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39909
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbXDPFGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 01:06:38 -0400
Date: Sun, 15 Apr 2007 22:06:39 -0700 (PDT)
Message-Id: <20070415.220639.41635818.davem@davemloft.net>
To: kyle@parisc-linux.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: modalias support for of_device
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070416041933.GE23783@athena.road.mcmartin.ca>
References: <20070416041933.GE23783@athena.road.mcmartin.ca>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@parisc-linux.org>
Date: Mon, 16 Apr 2007 00:19:33 -0400

> Quick patch to add modalias support for of_device to arch/sparc64 so
> sbus drivers can be automatically loaded (I hope :)
> 
> Untested, as I'm sparc-less at the moment.

Thanks Kyle.

How does this work?  Does some program walk through sysfs
scanning the attributes of devices, and this triggers
module matching?
