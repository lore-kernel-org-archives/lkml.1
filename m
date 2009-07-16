Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbZGPRC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbZGPRC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932781AbZGPRCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:02:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49668 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932621AbZGPRCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:02:55 -0400
Date: Thu, 16 Jul 2009 13:02:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Wu Zhangjin <wuzhangjin@gmail.com>
cc: linux-pm@lists.linux-foundation.org, <len.brown@intel.com>,
       <yanh@lemote.com>, <linux-kernel@vger.kernel.org>, <wuzj@lemote.com>,
       <zhangfx@lemote.com>
Subject: Re: [linux-pm] [PATCH] [suspend] pci_raw_set_power_state: replace
 msleep by udelay in resuming procedure
In-Reply-To: <1247759007-27411-1-git-send-email-wuzhangjin@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0907161259510.2952-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Wu Zhangjin wrote:

> we can not call msleep() when resuming from STR/Standby: if the
> current_state of the pci device is PCI_D3hot, means we are in the
> procedure of resuming, in this procedure, we can not re-schedule,
> otherwise, there will be a deadlock.

I don't understand.

First of all, why does current_state == PCI_D3hot mean the system is
resuming from sleep?  Isn't it possible that the PCI device is going
through a runtime resume?

Secondly, why will scheduling during a resume cause a deadlock?

Alan Stern

