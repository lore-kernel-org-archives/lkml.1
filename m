Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZIQRMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZIQRMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZIQRMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:12:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:5080 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbZIQRMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:12:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,404,1249282800"; 
   d="scan'208";a="188803106"
Date: Thu, 17 Sep 2009 10:12:19 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: kristen.c.accardi@intel.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/10] drivers/pci: Move a dereference below a NULL test
Message-ID: <20090917101219.19cb4da1@jbarnes-g45>
In-Reply-To: <Pine.LNX.4.64.0907191726360.16542@ask.diku.dk>
References: <Pine.LNX.4.64.0907191726360.16542@ask.diku.dk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jul 2009 17:26:58 +0200 (CEST)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> If the NULL test is necessary, then the dereference should be moved
> below the NULL test.
> 
> The semantic patch that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)

Sorry I missed this one.  Looks like it's been fixed another way
though...

-- 
Jesse Barnes, Intel Open Source Technology Center
