Return-Path: <linux-kernel-owner+w=401wt.eu-S1423075AbXBHPvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423075AbXBHPvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423083AbXBHPvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:51:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45925 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423075AbXBHPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:51:10 -0500
Date: Thu, 8 Feb 2007 15:51:08 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Greg KH <greg@kroah.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: device_destroy
Message-ID: <Pine.LNX.4.64.0702081548450.7686@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While porting over a few class_devices I discovered a problem with 
device_destroy. It uses a dev_t which several classes don't use. 
Should all classes require a dev_t or should we just pass in the device
itself?

