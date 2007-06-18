Return-Path: <linux-kernel-owner+w=401wt.eu-S1764063AbXFROpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764063AbXFROpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763316AbXFROp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:45:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:53052 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763118AbXFROp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:45:26 -0400
Date: Mon, 18 Jun 2007 16:45:34 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Ville =?utf-8?B?U3lyasOkbMOk?= <syrjala@sci.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: mach64 breakage in 2.6.22
Message-ID: <20070618144534.GA18150@aepfle.de>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070614082528.GA10284@aepfle.de> <20070614173623.GA7950@sci.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070614173623.GA7950@sci.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, Ville Syrjälä wrote:

> On Thu, Jun 14, 2007 at 10:25:28AM +0200, Olaf Hering wrote:
> > On Sat, May 05, Andrew Morton wrote:
> > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > 
> > > +atyfb-reorganize-clock-init.patch
> > 
> > This change breaks the display on an ibook1 with 800x600 lcd.
> 
> Are you sure?

Yes.

> Please try this patch:

>  	if (machine_is_compatible("PowerBook2,1")) {
>  		par->pll_limits.mclk = 70;
> -		par->pll_limits.xclk = 53;
> +		par->pll_limits.xclk = 106;

This oneliner fixes it for me.
