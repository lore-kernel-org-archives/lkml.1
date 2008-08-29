Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYH2JSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYH2JSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYH2JSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:18:39 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:37892 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYH2JSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:18:38 -0400
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller
	driver
From: Li Yang <leoli@freescale.com>
Reply-To: leoli@freescale.com
To: Scott Wood <scottwood@freescale.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080828163910.GA1185@ld0162-tx32.am.freescale.net>
References: <1219916613-28827-1-git-send-email-leoli@freescale.com>
	 <20080828163910.GA1185@ld0162-tx32.am.freescale.net>
Content-Type: text/plain
Organization: Freescale Semiconductor
Date: Fri, 29 Aug 2008 17:35:24 +0800
Message-Id: <1220002524.30607.18.camel@Gundam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Aug 2008 09:18:33.0039 (UTC) FILETIME=[35586DF0:01C909B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 11:39 -0500, Scott Wood wrote:
> On Thu, Aug 28, 2008 at 05:43:33PM +0800, Li Yang wrote:
> > +config USB_GADGET_FSL_QE
> > +	boolean "Freescale QE/CPM USB Device Controller"
> > +	depends on FSL_SOC && (QUICC_ENGINE || CPM)
> > +	help
> > +	   Some of Freescale PowerPC processors have a Full Speed
> > +	   QE/CPM2 USB controller, which support device mode with 4
> > +	   programmable endpoints. This driver supports the
> > +	   controller in the MPC8360 and MPC8272, and should work with
> > +	   controllers having QE or CPM2, given minor tweaks.
> > +
> > +	   Say "y" to link the driver statically, or "m" to build a
> > +	   dynamically linked module called "fsl_qe_udc" and force all
> > +	   gadget drivers to also be dynamically linked.
> 
> How can you say "m" to something that is not a tristate?

Well, I copied these from other udc drivers.  Udc drivers can be
compiled as module, through the CONFIG_USB_GADGET option.  Though, the
description here is not accurate.

- Leo

