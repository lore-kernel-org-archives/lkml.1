Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYHSQsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYHSQsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbYHSQrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:47:51 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38933 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbYHSQrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:47:49 -0400
Date: Mon, 18 Aug 2008 16:19:54 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: create device, function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080818231954.GA6080@us.ibm.com>
References: <20080818202100.GE23155@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818202100.GE23155@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 02:21:00PM -0600, Alex Chiang wrote:
> Create convenience symlinks in sysfs, linking slots to devices
> and functions, and vice versa. These links make it easier for
> users to figure out which devices actually live in what slots.

This looks it would be quite useful but the symlinks are not adjusted
during hot-add and hot-remove operations (e.g. stale symlinks persist
after hot-remove and new symlinks are not created in response to hot-add)
so it could confuse more than help on systems with PCI hotplug support.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
