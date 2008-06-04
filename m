Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbYFDQSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbYFDQSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 12:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYFDQRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 12:17:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:45107 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbYFDQRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,590,1204531200"; 
   d="scan'208";a="390465874"
Date: Wed, 4 Jun 2008 09:08:01 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] expand link_power_management_policy definition
Message-ID: <20080604090801.4c5a7658@appleyard>
In-Reply-To: <4845E761.2090604@garzik.org>
References: <20080603172307.1b963aac@appleyard>
	<4845E761.2090604@garzik.org>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2008 20:52:49 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Kristen Carlson Accardi wrote:
> > I think I mentioned on the list a couple weeks ago that I favor just 
> > expanding the definition of link power management to include
> > the notion of simply powering the entire port off rather
> > than adding new knobs to sysfs.  I wrote this completely untested and
> > very incomplete patch to give you a better idea of what I am proposing.
> > This patch adds a new valid value of "power_off" for the existing
> > link_power_management_policy sysfs entry:
> 
> Looks fine to me...  that would work nicely.
> 
> I think your patch is missing code to handle the transition from 
> power_off to <something else>, though, right?
> 
> I'm quite happy with this approach.
> 
> 	Jeff
> 
> 
> 

yeah - it's missing a lot.  I'll flesh it out some more and
send a real one.

