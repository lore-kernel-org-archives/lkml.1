Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYDWWvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYDWWvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYDWWvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:51:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:16739 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYDWWvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:51:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,701,1199692800"; 
   d="scan'208";a="320603721"
From: Jesse Barnes <jesse.barnes@intel.com>
To: alek du <alek.du@intel.com>
Subject: Re: [PATCH 1/3] pci: Add Intel SCH PCI IDs
Date: Wed, 23 Apr 2008 15:51:04 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
References: <20080422100140.71f947ca@dxy.sh.intel.com>
In-Reply-To: <20080422100140.71f947ca@dxy.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231551.05220.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2008 7:01 pm alek du wrote:
> This patch adds Intel SCH chipsets (US15W, US15L, UL11L) PCI IDs, these IDs
> will be used by following SCH driver patches.
>
> Signed-off-by: Alek Du <alek.du@intel.com>
> ---
>  include/linux/pci_ids.h |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)

Alex, can any of these IDs be trimmed?  We only want to bloat pci_ids.h with 
the stuff that's actually used in several drivers.  Other IDs can just be 
defined directly in the driver in question...

Thanks,
Jesse
