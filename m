Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYLSGey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYLSGey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 01:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYLSGep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 01:34:45 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:56101 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYLSGeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 01:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J2lNs9nWO0vNZUrU1EGM6Jjzv6ogscMhm+o3W1eFuC9ed6pZ+Zl3qYbIVKnHz0mYTX
         Wi0vNjdArubDwMURp/M1j82TkFLdL5PSEivebAW+kGtEmx/1PunYSlC0QGOol1UeW4dF
         oW4nPXP2Qwlkt5BxVEe41ilaUILdmZg5Mxp9E=
Date: Fri, 19 Dec 2008 14:34:15 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix some code style that line over 80 characters
Message-ID: <20081219063415.GB3309@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
References: <20081210135143.GB4595@helight> <20081210150116.GB21396@x200.localdomain> <20081218112617.09fd97bd.randy.dunlap@oracle.com> <20081218193059.GA31274@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218193059.GA31274@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 07:30:59PM +0000, Russell King wrote:
> On Thu, Dec 18, 2008 at 11:26:17AM -0800, Randy Dunlap wrote:
> > On Wed, 10 Dec 2008 18:01:16 +0300 Alexey Dobriyan wrote:
> > 
> > > On Wed, Dec 10, 2008 at 09:51:43PM +0800, Helight.Xu wrote:
> > > > -static inline struct s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct device *dev)
> > > > +static inline struct
> > > > +s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct device *dev)
> > > 
> > > NAK!
> > 
> > OK, but please includes reason(s) for NAKs...
> 
> I can provide a reason - it splits "struct" and the structure name
> across different lines.  That manes 'struct s3c2410_platform_i2c'
> hard to grep for.
yes, it should be:
static inline
struct s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct device *dev)
> 
> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn
