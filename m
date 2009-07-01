Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZGAQcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZGAQcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZGAQce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:32:34 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44860 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbZGAQcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:32:33 -0400
Date: Wed, 1 Jul 2009 17:32:35 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] i915: fix up a raw 64bit divide
Message-ID: <20090701163235.GG13837@shadowen.org>
References: <1246458059-15965-1-git-send-email-apw@canonical.com> <20090701091255.363f9d4d@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701091255.363f9d4d@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 09:12:55AM -0700, Jesse Barnes wrote:
> On Wed,  1 Jul 2009 15:20:59 +0100
> Andy Whitcroft <apw@canonical.com> wrote:
> 
> > We are seeing compilation failures on i386 in some environments due
> > to an undefined reference as below:
> > 
> >     ERROR: "__udivdi3" [drivers/gpu/drm/i915/i915.ko] undefined!
> > 
> > This is generated due to a raw 64 bit divide in the i915 driver.  Fix
> > up this raw divide.
> > 
> > Signed-off-by: Andy Whitcroft <apw@canonical.com>
> 
> I think building with newer GCCs will prevent this error, but the fix
> looks fine.

Yeah I suspect gcc interactions here, as builds on older userspace were
failing in this way but not so in the very latest karmic userspace.  I
suspect its still correct to avoid these currently.

> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Thanks.

-apw
