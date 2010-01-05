Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736Ab0AEPBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0AEPBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687Ab0AEPBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:01:18 -0500
Received: from kroah.org ([198.145.64.141]:43202 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab0AEPBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:01:00 -0500
Date: Tue, 5 Jan 2010 06:53:09 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/12] SYSFS: Add sysfs_add/remove_files utility
 functions
Message-ID: <20100105145309.GD11732@kroah.com>
References: <201001051247.104464547@firstfloor.org>
 <20100105114801.7F8B5B17C2@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105114801.7F8B5B17C2@basil.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 12:48:01PM +0100, Andi Kleen wrote:
> 
> Adding/Removing a whole array of attributes is very common. Add a standard
> utility function to do this with a simple function call, instead of
> requiring drivers to open code this.

Hm, that is what the sysfs_create_group(), sysfs_update_group(), and
sysfs_remove_group() functions are for.  We don't need to add any new
functions that do the same thing, right?

thanks,

greg k-h
