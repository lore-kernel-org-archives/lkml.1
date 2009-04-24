Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbZDXUsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbZDXUsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 16:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZDXUr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 16:47:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbZDXUr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 16:47:56 -0400
Date: Fri, 24 Apr 2009 11:44:25 -0700
From: Greg KH <gregkh@suse.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] driver/base: add BUS_NOTIFY_UNBOUND_DRIVER event
Message-ID: <20090424184425.GB20845@suse.de>
References: <1240577820-13783-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240577820-13783-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 02:57:00PM +0200, Joerg Roedel wrote:
> This patch adds a new bus notifier event which is emitted _after_ a
> device is removed from its driver. This event will be used by the
> dma-api debug code to check if a driver has released all dma allocations
> for that device.

Heh, I was wondering if people were going to need that.  I'll queue it
up for 2.6.31, is that ok with you?  Do you have patches that depend on
it?

thanks,

greg k-h
