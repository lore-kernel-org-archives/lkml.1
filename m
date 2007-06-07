Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbXFGJiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbXFGJiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 05:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbXFGJiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 05:38:16 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:34761 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbXFGJiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 05:38:15 -0400
Date: Thu, 7 Jun 2007 18:37:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm2
Message-ID: <20070607093702.GA19759@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Manuel Lauss <mano@roarinelk.homelinux.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070607064231.GQ6909@holomorphy.com> <20070607071138.GA15420@linux-sh.org> <20070607091942.GA1584@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607091942.GA1584@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 11:19:42AM +0200, Manuel Lauss wrote:
> On Thu, Jun 07, 2007 at 04:11:38PM +0900, Paul Mundt wrote:
> > On Wed, Jun 06, 2007 at 11:42:31PM -0700, William Lee Irwin III wrote:
> > > sound/soc/sh/Kconfig:6:warning: 'select' used by config symbol 'SND_SOC_PCM_SH7760' refers to undefined symbol 'SH_DMABRG'
> 
> ---
> 
> Make SND_SOC_PCM_SH7760 depend on SH_DMABRG rather than selecting it
> 
> Fixes Kconfig warning about undefined SH_DMABRG symbol on non-sh builds.
> 
Are you sure this is the way you want to go? The select here is
reasonably useful.
