Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbZHMWaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbZHMWaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 18:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZHMWaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 18:30:21 -0400
Received: from kroah.org ([198.145.64.141]:41722 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081AbZHMWaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:30:21 -0400
Date: Thu, 13 Aug 2009 15:28:01 -0700
From: Greg KH <greg@kroah.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, len.brown@intel.com,
       stable@kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       ranma+kernel@tdiedrich.de
Subject: Re: [stable] patch
 thinkpad-acpi-fix-incorrect-use-of-tpacpi_brght_mode_ecnvram.patch added
 to 2.6.30-stable tree
Message-ID: <20090813222801.GA9102@kroah.com>
References: <20090805205011.57FB548DF1@coco.kroah.org>
 <200908070108.15095.s.L-H@gmx.de>
 <20090806233111.GB14381@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806233111.GB14381@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 08:31:11PM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 07 Aug 2009, Stefan Lippers-Hollmann wrote:
> > This patch fails to compile if applied to 2.6.30 + current stable queue.
> [...]
> > It seems to depend on the new quirk handling, introduced in:
> > commit 7d95a3d564901e88ed42810f054e579874151999
> 
> Good catch.  And I _will_ need that quirk handling stuff to keep 2.6.30 in
> shape :-(

Oops, sorry for missing this.

> The dependencies for the "thinkpad-acpi: fix incorrect use of
> TPACPI_BRGHT_MODE_ECNVRAM" patch are:

Due to the need to add a new feature just to get these quirks to work,
I'll just drop this single patch, which should keep everything building
properly, right?

thanks,

greg k-h
