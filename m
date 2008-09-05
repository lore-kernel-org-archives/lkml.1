Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbYIESK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbYIESK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYIESKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:10:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791AbYIESKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:10:17 -0400
Date: Fri, 5 Sep 2008 11:09:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] platform: add new device registration helper
Message-Id: <20080905110937.c1a3d3f1.akpm@linux-foundation.org>
In-Reply-To: <20080905103318.GB25622@doriath.ww600.siemens.net>
References: <1220563816-8106-1-git-send-email-dbaryshkov@gmail.com>
	<20080904172050.cbde3013.akpm@linux-foundation.org>
	<20080905103318.GB25622@doriath.ww600.siemens.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 14:33:18 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> On Thu, Sep 04, 2008 at 05:20:50PM -0700, Andrew Morton wrote:
> > On Fri,  5 Sep 2008 01:30:16 +0400
> > Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> > 
> > > Add a helper that registers simple platform_device
> > > w/o resources but with parent and device data.
> > > 
> > > This is usefull to cleanup platform code from code that
> > > registers such simple devices as leds-gpio, generic-bl,
> > > etc.
> > > 
> > 
> > nits:
> > 
> > > + *
> > > + * This function creates a simple platform device that requires minimal
> > > + * resource and memory management. Canned release function freeing memory
> > > + * allocated for the device allows drivers using such devices to be
> > > + * unloaded without waiting for the last reference to the device to be
> > > + * dropped.
> > 
> > Should document the return value (tested with IS_ERR)
> 
> Will the wording "Returns a valid platform device, or a valid IS_ERR
> condition containing errno" be appropriate?

Sounds good.

> 
> BTW: would you prefer the followup "fix" patch or just the replacement
> one?
> 

Doesn't worry me at this stage, but Greg would probably like a whole
new patch, as he probably didn't merge version 1.
