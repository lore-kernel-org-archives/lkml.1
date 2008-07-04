Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbYGDJGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbYGDJGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 05:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYGDJGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 05:06:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:23893 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYGDJGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 05:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V+uqISvlnAO2yqpAR18ykP6Ix98/DHEyl2+4OPoOSB/Y9lyl0S7joDRY2fmpZwWMYn
         j4HFlcU4CVzzBr0/oFJDEY15Ih7MkhGeokxZdcZxaBJc5FwyyXHe33urvxbVPXMPL7zs
         kLWXuD95eOoPatiQk0w+RXU3xZ311+W0ytN6s=
Date: Fri, 4 Jul 2008 13:05:47 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: Re: [PATCH 0/3] Clocklib: generic framework for clocks managing
	[v3]
Message-ID: <20080704090547.GB6848@doriath.ww600.siemens.net>
References: <20080626125033.GA7093@doriath.ww600.siemens.net> <20080703202250.GA24620@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703202250.GA24620@fluff.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 09:22:50PM +0100, Ben Dooks wrote:
> On Thu, Jun 26, 2008 at 04:50:33PM +0400, Dmitry Baryshkov wrote:
> > Hi,
> > 
> > This is again a set of patches to unify the management of clocks and
> > allow easy registration and unregistration of them. This is neccessary
> > to cleanly support such devices as toshiba mobile companion chips,
> > sa1111 companion, etc. Also it brings code unification, especially for a
> > lot of arm sub-arches which share nearly the same code, etc.
> > 
> > This is the "version 3" approach. Given the negative response to
> > kobjects, I've redesigned it to use plain krefs.
> > 
> > Debugfs support is merged into main clocklib patch. Documentation
> > for it's interface will come later. For now it provides tree structure
> > with single file per each clock directory.
> 
> I'd prefer not to see this called clocklib, it isn't of any use
> outside of the kernel, and once it is in there's little point in
> anyone not using it.

Please propose better name.

> 
> -- 
> Ben (ben@fluff.org, http://www.fluff.org/)
> 
>   'a smiley only costs 4 bytes'

-- 
With best wishes
Dmitry

