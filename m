Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbZDFSqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbZDFSqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757837AbZDFSqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:46:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:37925 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746AbZDFSqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:46:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,331,1235980800"; 
   d="scan'208";a="400805251"
Date: Mon, 6 Apr 2009 11:45:55 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Fix oops in pci_vpd_truncate
Message-ID: <20090406114555.28a8aa57@hobbes>
In-Reply-To: <20090331222341.GA16479@oksana.dev.rtsoft.ru>
References: <20090331222341.GA16479@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 02:23:41 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> pci_vpd_truncate() should check for dev->vpd->attr, otherwise
> this might happen:

Applied this to my for-linus branch, thanks Anton.

-- 
Jesse Barnes, Intel Open Source Technology Center
