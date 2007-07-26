Return-Path: <linux-kernel-owner+w=401wt.eu-S934058AbXGZO2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058AbXGZO2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760818AbXGZO2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:28:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42379 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759938AbXGZO2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:28:40 -0400
Date: Thu, 26 Jul 2007 10:28:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 8535] USB input death then system freeze
In-Reply-To: <20070725222332.B84EF11C002@picon.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0707261022260.3529-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun:

Please take a look at comment #50 in Bugzilla 8535:

	http://bugzilla.kernel.org/show_bug.cgi?id=8535#c50

There have been several reports like this one recently of BUGs
occurring in release_sysfs_dirent() during device unregistration.  
Obviously a use-after-free issue, probably caused by a refcounting 
error.

Is there already a patch available to fix it?

Thanks,

Alan Stern

