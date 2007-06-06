Return-Path: <linux-kernel-owner+w=401wt.eu-S936113AbXFFWZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936113AbXFFWZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934646AbXFFWZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:25:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:31409 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764852AbXFFWZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:25:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="236394209"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 6 Jun 2007 15:24:50 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <200706061505.11741.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061813260.4961@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706061813260.4961@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061524.52628.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 6, 2007 3:13 pm Justin Piszcz wrote:
> On Wed, 6 Jun 2007, Jesse Barnes wrote:
> > On Wednesday, June 6, 2007 3:03 pm Justin Piszcz wrote:
> >> Mem:   8039620k total,  7936472k used,   103148k free,      708k
> >> buffers Mem:   8039608k total,   969380k used,  7070228k free,
> >> 1232k buffers
> >>
> >> I am curious, why does the patch != the mem=8832M?
> >
> > I'm not sure... can you post your e820 map from boot and the
> > contents of /proc/mtrr?  Maybe my patch is trimming off a few too
> > many pages, or maybe 8832M isn't quite right and actually ends up
> > leaving you with a few uncached pages.
> >
> > Jesse
>
> Unless you know of some other way I can capture the output, it only
> starts showing the dmesg from [50..] onward.

Did you boot the kernel with the 'debug' option?  Maybe your dmesg 
buffer is too small (there's a config option for that iirc).

Jesse
