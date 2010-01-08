Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163Ab0AHV2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0AHV2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092Ab0AHV2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:28:13 -0500
Received: from outbound-mail-303.bluehost.com ([67.222.53.10]:36922 "HELO
	outbound-mail-303.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754133Ab0AHV2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:28:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=knV2IhyP2a/pcSRCMqXdxwQrNobHmd/MsJ0KvIo/Xn0xnxiwA+uXuvYxZ4vAU9tFmHLtWt508rfS4wABE5mf0bAvvckQN6HhjGAdlLBvlSr1XHrFEDCJL6M1lBX+XljT;
Date: Fri, 8 Jan 2010 13:28:12 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H Hartley Sweeten" <hartleys@visionengravers.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       <dri-devel@lists.sourceforge.net>, <airlied@linux.ie>
Subject: Re: [PATCH] drivers/gpu/drm/i915/i915_debugfs.c: remove unnecessary
 casts
Message-ID: <20100108132812.0779f5b1@jbarnes-piketon>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090208974B@mi8nycmail19.Mi8.com>
References: <201001081418.01471.hartleys@visionengravers.com>
	<20100108132049.27e4b1cf@jbarnes-piketon>
	<BD79186B4FD85F4B8E60E381CAEE19090208974B@mi8nycmail19.Mi8.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010 16:24:02 -0500
"H Hartley Sweeten" <hartleys@visionengravers.com> wrote:

> On Friday, January 08, 2010 2:21 PM, Jesse Barnes wrote:
> > On Fri, 8 Jan 2010 14:18:01 -0700
> > H Hartley Sweeten <hartleys@visionengravers.com> wrote:
> >
> >> drivers/gpu/drm/i915/i915_debugfs.c: Remove unnecessary casts.
> >> 
> >> The struct seq_file 'private' member is a void *, the casts are not
> >> needed.
> >> 
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >> Cc: David Airlie <airlied@linux.ie>
> >
> > This one should go to Eric Anholt <eric@anholt.net>, and why not
> > just do a full "drm/i915: remove unnecessary casts" patch all at
> > once?  That would probably be easier for Eric.
> 
> Yah, I just noticed there are a number of them in drivers/gpu/drm/*.
> 
> Can Eric Anholt handle all of them or just the i915 specific ones?

Just i915, the rest go through Dave.

-- 
Jesse Barnes, Intel Open Source Technology Center
