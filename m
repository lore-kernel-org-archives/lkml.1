Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYFWFGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYFWFGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 01:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYFWFGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 01:06:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:22832 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbYFWFGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 01:06:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,687,1204531200"; 
   d="scan'208";a="1166667"
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <200806230530.44283.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <200806162021.37105.Michal.Kudla@gmail.com>
	 <1213665088.2533.24.camel@debian.sh.intel.com>
	 <200806230530.44283.Michal.Kudla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Organization: Intel Corp.
Date: Mon, 23 Jun 2008 13:05:51 +0800
Message-Id: <1214197551.14590.148.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 05:30 +0200, Michał Kudła wrote:
> >ZY Your radio is disabled by the software rf_kill switch. Please do a
> >ZY $ echo 0 > /sys/bus/pci/drivers/iwl4965/<dev id>/rfkill
> \:rfkill0/state
> 
> Still don't work

Oops, you should echo 1 instead.

Thanks,
-yi

