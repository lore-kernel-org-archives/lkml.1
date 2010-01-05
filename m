Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771Ab0AEPBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab0AEPBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704Ab0AEPBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:01:17 -0500
Received: from kroah.org ([198.145.64.141]:43204 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab0AEPBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:01:01 -0500
Date: Tue, 5 Jan 2010 06:53:22 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/12] SYSFS: Pass attribute in sysdev_class
 attributes show/store
Message-ID: <20100105145322.GE11732@kroah.com>
References: <201001051247.104464547@firstfloor.org>
 <20100105114758.7773BB17C2@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105114758.7773BB17C2@basil.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 12:47:58PM +0100, Andi Kleen wrote:
> 
> Passing the attribute to the low level IO functions allows all kinds
> of cleanups, by sharing low level IO code without requiring
> an own function for every piece of data.
> 
> Also drivers can extend the attributes with own data fields
> and use that in the low level function.
> 
> Similar to sysdev_attributes and normal attributes.
> 
> This is a tree-wide sweep, converting everything in one go.
> 
> No functional changes in this patch other than passing the new
> argument everywhere.
> 
> Tested on x86, the non x86 parts are uncompiled.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Looks good, I'll queue this up.

greg k-h
