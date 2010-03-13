Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab0CMIeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 03:34:09 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:60229 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758910Ab0CMIeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 03:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B8eGl0B/reUWxzOdxwT2w5uTFpEQqz/uL7jYw7CUAp8+WVvkOmnQmLdNUzx91+RI/g
         TeVvFxWnYckVqJtCKyD1qwMRy73OeA6O/XNrznlopZrtnxilb2f3Qxsdw0MypB/3dVws
         4hS0n1aMh1+Jdr54jZe4F4wgEMv9KdZLz4NZ4=
Date: Sat, 13 Mar 2010 00:33:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/mips/txx9/generic: init dynamic bin_attribute
 structures
Message-ID: <20100313083359.GB22494@core.coreip.homeip.net>
References: <1268377431-11671-1-git-send-email-w.sang@pengutronix.de>
 <1268377431-11671-2-git-send-email-w.sang@pengutronix.de>
 <20100312183450.GC8736@core.coreip.homeip.net>
 <20100313022855.GD4034@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313022855.GD4034@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 03:28:55AM +0100, Wolfram Sang wrote:
> On Fri, Mar 12, 2010 at 10:34:51AM -0800, Dmitry Torokhov wrote:
> > On Fri, Mar 12, 2010 at 08:03:49AM +0100, Wolfram Sang wrote:
> > > Commit 6992f5334995af474c2b58d010d08bc597f0f2fe introduced this requirement.
> > > Found with coccinelle, but fixed manually. Compile tested on X86 where
> > > possible.
> > > 
> > 
> > Regarding all 3 - it looks like these dynamically alocated attributes
> > could be converted to statically allocated ones. I'd recommend doing
> > that instead (in fact, I posted patch for the firmware_class couple days
> > ago).
> 
> I agree for the firmware-patch. Regarding the MIPS one, 'size' might differ and
> 'private' will differ per instance. Regarding the RTC driver, 'size' might also
> differ. I don't know if somebody really wants two RTCs or the SRAM for MIPS can
> be instantiated more than once. Unless somebody with actual hardware jumps in,
> I'd say better safe than sorry.
> 

Ah, right, size... I forgot about it. You are right, making the other 2
static is not an option.

-- 
Dmitry
