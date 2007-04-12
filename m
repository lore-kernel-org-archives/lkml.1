Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbXDLVNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbXDLVNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbXDLVNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:13:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:8798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbXDLVNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:13:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,405,1170662400"; 
   d="scan'208"; a="72747526:sNHT18449649"
Date: Thu, 12 Apr 2007 14:13:34 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: kernel-janitors@lists.osdl.org, linux-ia64@vger.kernel.org,
       discuss@x86-64.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de
Subject: Re: [KJ][PATCH 02/03]ROUND_UP|DOWN macro cleanup in arch/ia64,x86_64
Message-ID: <20070412211334.GA5892@intel.com>
References: <20070412203140.GB9353@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412203140.GB9353@arun.site>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 02:01:40AM +0530, Milind Arun Choudhary wrote:
> -	size = ROUNDUP(size, iovp_size);
> +	size = ALIGN(size, iovp_size);

Why is "ALIGN" better than "ROUNDUP"?  I can't see any point
to this change.

-Tony
