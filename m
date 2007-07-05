Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbXGEWee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbXGEWee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759363AbXGEWeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:34:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758575AbXGEWeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:34:22 -0400
Date: Thu, 5 Jul 2007 15:33:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk,
       linux-scsi@vger.kernel.org
Subject: Re: [patch 3/4] Enable link power management for ata drivers
Message-Id: <20070705153334.08402809.akpm@linux-foundation.org>
In-Reply-To: <20070705130530.5873afeb.kristen.c.accardi@intel.com>
References: <20070705194909.337398431@intel.com>
	<20070705130530.5873afeb.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007 13:05:30 -0700
Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:

> +	ATA_DFLAG_IPM		= (1 << 6), /* device supports interface PM */
>  	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,

I had to bump this to (1<<7), so we've run out.
