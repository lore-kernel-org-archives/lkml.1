Return-Path: <linux-kernel-owner+w=401wt.eu-S935859AbXFFWFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935859AbXFFWFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934844AbXFFWF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:05:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:48242 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935121AbXFFWF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:05:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="236387371"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 6 Jun 2007 15:05:10 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061747180.3697@p34.internal.lan> <Pine.LNX.4.64.0706061803040.4671@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706061803040.4671@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061505.11741.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 6, 2007 3:03 pm Justin Piszcz wrote:
> Mem:   8039620k total,  7936472k used,   103148k free,      708k
> buffers Mem:   8039608k total,   969380k used,  7070228k free,    
> 1232k buffers
>
> I am curious, why does the patch != the mem=8832M?

I'm not sure... can you post your e820 map from boot and the contents 
of /proc/mtrr?  Maybe my patch is trimming off a few too many pages, or 
maybe 8832M isn't quite right and actually ends up leaving you with a 
few uncached pages.

Jesse
