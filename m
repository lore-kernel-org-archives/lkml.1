Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYHTTLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYHTTLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYHTTKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:10:51 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33470 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbYHTTKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:10:51 -0400
Subject: Re: [Devel] [RFC][PATCH 1/4] checkpoint-restart: general
	infrastructure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <48A94061.8040206@openvz.org>
References: <20080807224033.FFB3A2C1@kernel>
	 <20080807224034.735B1F84@kernel>  <48A94061.8040206@openvz.org>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 12:10:45 -0700
Message-Id: <1219259445.8960.45.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 13:26 +0400, Pavel Emelyanov wrote: 
> > diff -puN /dev/null ckpt/ckpt_hdr.h
> > --- /dev/null	2007-04-11 11:48:27.000000000 -0700
> > +++ linux-2.6.git-dave/ckpt/ckpt_hdr.h	2008-08-07 15:37:22.000000000 -0700
> > @@ -0,0 +1,69 @@
> > +/*
> > + *  Generic container checkpoint-restart
> > + *
> > + *  Copyright (C) 2008 Oren Laadan
> > + *
> > + *  This file is subject to the terms and conditions of the GNU General Public
> > + *  License.  See the file COPYING in the main directory of the Linux
> > + *  distribution for more details.
> > + */
> > +
> > +#include <linux/types.h>
> > +
> > +struct cr_hdr {
> > +	__s16 type;
> > +	__s16 len;
> > +	__u32 id;
> > +};
> 
> Sorry for probably being out-of-date again, but isn't it better to
> put these headers in the include/linux and export them to the user
> space?
> 
> Why? Because we'll need some image-dumping tool (let alone the
> image converting one for compatibility purposes) and these tools
> would require to know how the image looks like.

What's the deal with headers being exported these days?  Don't we always
have to sanitize them before we ship them over to userspace anyway?

-- Dave

