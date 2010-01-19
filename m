Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648Ab0ASAP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0ASAP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288Ab0ASAPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:15:16 -0500
Received: from kroah.org ([198.145.64.141]:57304 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab0ASAPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:15:15 -0500
Date: Mon, 18 Jan 2010 16:13:20 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Move rar_register.h file to include/linux/rar
Message-ID: <20100119001320.GE27551@kroah.com>
References: <1263849744-23098-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263849744-23098-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 01:22:24PM -0800, Mark Allyn wrote:
> The purpose of this patch is to move the rar_register.h file from
> the driver source code directory to a subdirectory in the kernel's
> include tree; at incluce/linux/rar.

No, staging drivers are self-contained within their drivers/staging/
directory.  No placing code outside of them otherwise bad things will
happen.

thanks,

greg k-h
