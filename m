Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZAUUhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZAUUhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 15:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZAUUhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 15:37:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38623
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbZAUUhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:37:37 -0500
Date: Wed, 21 Jan 2009 12:37:39 -0800 (PST)
Message-Id: <20090121.123739.97186745.davem@davemloft.net>
To: gerickson@nuovations.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Add Alternative Log Buffer Support for printk Messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1232559586-9164-1-git-send-email-gerickson@nuovations.com>
References: <1232559586-9164-1-git-send-email-gerickson@nuovations.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Erickson <gerickson@nuovations.com>
Date: Wed, 21 Jan 2009 09:39:46 -0800

> This merges support for the previously DENX-only kernel feature of
> specifying an alternative, "external" buffer for kernel printk
> messages and their associated metadata. In addition, this ports
> architecture support for this feature from arch/ppc to arch/powerpc.
> 
> When this option is enabled, an architecture- or machine-specific log
> buffer is used for all printk messages. This allows entities such as
> boot loaders (e.g. U-Boot) to place printk-compatible messages into
> this buffer and for the kernel to coalesce them with its normal
> messages.
> 
> Signed-off-by: Grant Erickson <gerickson@nuovations.com>

Nice.

This would also be useful on Sparc where it is possible to tell
the firmware to set aside a piece of physical memory which survives
soft resets and thus can be inspected post reboot.
