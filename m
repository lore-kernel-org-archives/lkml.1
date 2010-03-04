Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab0CDBRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:17:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:49442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab0CDBRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:17:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,577,1262592000"; 
   d="scan'208";a="601120817"
Date: Thu, 4 Mar 2010 09:17:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Wei Ni <wni@nvidia.com>, "'akpm'" <akpm@linux-foundation.org>,
       "'alsa-devel'" <alsa-devel@alsa-project.org>,
       "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'Pavel Hofman'" <pavel.hofman@insite.cz>
Subject: Re: [alsa-devel]  [PATCH]Support MCP89 and GT21x hdmi audio
Message-ID: <20100304011707.GA6462@localhost>
References: <6B4D417B830BC44B8026029FD256F7F1C068B2BA8B@HKMAIL01.nvidia.com> <20100302054307.GA6165@localhost> <s5h8wa9oqbi.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8wa9oqbi.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 02:46:25PM +0800, Takashi Iwai wrote:
> At Tue, 2 Mar 2010 13:43:07 +0800,
> Wu Fengguang wrote:
> > 
> > On Mon, Mar 01, 2010 at 07:27:53PM +0800, Wei Ni wrote:
> > > Hi, Takashi
> > > I developed the hdmi audio driver for new chipset MCP89 and GT21x.
> > > The new HAD controller and codec support standard HDMI operation.
> > > 
> > > I attached the patch file, please check it.
> > 
> > Wei Ni,
> > 
> > Can we avoid the big copy&paste and do more code reuse?
> > This benefits all of us in long term.
> 
> The plan is to merge all current patch_*hdmi.c into one.
> But this can be done later once after we get the working driver
> for the new Nvidia codecs.
> 
> The new Nvidia HDMI codec is a bit tricky (which has 4 separate
> codec slots), so I'd like to get it working first.

OK, it makes sense to solve one problem at a time.

Wei Ni, would you ensure these naming rules:

- unmodified functions: keep the original function name hdmi_*
  (if the original function name is intelhdmi_*, rename it to hdmi_*)

- modified function: rename function name to nvhdmi_*
  (if the original function name is hdmi_*, rename it to intel_hdmi_*)

And do the same for data structures, enums, variables, etc.

This hopefully will make it easier to do the future merge.

Thanks,
Fengguang
