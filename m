Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbXISVxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbXISVxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXISVxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:53:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:41953 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXISVxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:53:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,275,1186383600"; 
   d="scan'208";a="282500322"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Howard Chu <hyc@symas.com>
Subject: Re: MTRR initialization
Date: Wed, 19 Sep 2007 14:52:57 -0700
User-Agent: KMail/1.9.7
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <46EAB7DA.10507@symas.com>
In-Reply-To: <46EAB7DA.10507@symas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709191452.57505.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 14, 2007 9:33 am Howard Chu wrote:
> So the question is - was there an easier/correct way to do this?
>
> It might have been nice if the MTRR ioctls allowed the register
> number to be specified on the Set commands, though I'm not sure that
> would have helped in this case.

To do this in a nicer way (and be less vulnerable to similar BIOS 
funkiness) the kernel really needs full PAT support.  That should allow 
WC over WB and WC over UC mappings to occur, at least if I'm 
remembering the docs right...

Jesse
