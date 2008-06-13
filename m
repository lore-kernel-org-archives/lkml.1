Return-Path: <linux-kernel-owner+w=401wt.eu-S1760932AbYFMD4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932AbYFMD4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 23:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbYFMD42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 23:56:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759708AbYFMDzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 23:55:55 -0400
Date: Thu, 12 Jun 2008 20:50:55 -0700
From: Greg KH <greg@kroah.com>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 12/21] perfmon2 minimal: sysfs interface
Message-ID: <20080613035055.GD17872@kroah.com>
References: <484daff1.1358560a.0808.0267@mx.google.com> <20080611144955.GA20145@kroah.com> <7c86c4470806110800w465f1c91k7e8f0bb8fba18ca3@mail.gmail.com> <7c86c4470806120554w38a11307qa34511cf4f8b4aba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470806120554w38a11307qa34511cf4f8b4aba@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 02:54:15PM +0200, stephane eranian wrote:
> Greg,
> 
> I looked at the documentation and the examples.
> 
> Find attached an updated version of the perfmon-sysfs.diff patch.
> 
> I have grouped attribute functions into common show/store functions
> with a strcmp on
> the attribute name. I have also used the kobject_init_and_add() function.
> 
> Once thing still confusing to me is the business with kobject_put()
> after a kobject_init_and_add().
> Is that necessary to drop the ref count to zero?

Yes.

> Also when you link to a parent,  like this:
> 	pfm_kernel_kobj = kobject_create_and_add("perfmon", kernel_kobj);
> 
> Does this increment the ref count on the parent?

Yes.

thanks,

greg k-h
