Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYH1RC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYH1RC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYH1RCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:02:50 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:57026 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYH1RCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:02:49 -0400
Date: Thu, 28 Aug 2008 11:39:10 -0500
From: Scott Wood <scottwood@freescale.com>
To: Li Yang <leoli@freescale.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller driver
Message-ID: <20080828163910.GA1185@ld0162-tx32.am.freescale.net>
References: <1219916613-28827-1-git-send-email-leoli@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219916613-28827-1-git-send-email-leoli@freescale.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 05:43:33PM +0800, Li Yang wrote:
> +config USB_GADGET_FSL_QE
> +	boolean "Freescale QE/CPM USB Device Controller"
> +	depends on FSL_SOC && (QUICC_ENGINE || CPM)
> +	help
> +	   Some of Freescale PowerPC processors have a Full Speed
> +	   QE/CPM2 USB controller, which support device mode with 4
> +	   programmable endpoints. This driver supports the
> +	   controller in the MPC8360 and MPC8272, and should work with
> +	   controllers having QE or CPM2, given minor tweaks.
> +
> +	   Say "y" to link the driver statically, or "m" to build a
> +	   dynamically linked module called "fsl_qe_udc" and force all
> +	   gadget drivers to also be dynamically linked.

How can you say "m" to something that is not a tristate?

-Scott
