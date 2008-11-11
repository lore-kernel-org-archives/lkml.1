Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYKKGfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYKKGfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbYKKGfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:35:07 -0500
Received: from kroah.org ([198.145.64.141]:37870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755541AbYKKGfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:35:04 -0500
Date: Mon, 10 Nov 2008 22:26:55 -0800
From: Greg KH <greg@kroah.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/5] i5k_amb: Load automatically on all 5000/5400
	chipsets
Message-ID: <20081111062655.GI13156@kroah.com>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com> <20081107185631.13022.59600.stgit@elm3a70.beaverton.ibm.com> <20081108120950.397a3165@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081108120950.397a3165@hyperion.delvare>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 12:09:50PM +0100, Jean Delvare wrote:
> Hi Darrick,
> 
> On Fri, 07 Nov 2008 10:56:31 -0800, Darrick J. Wong wrote:
> > It turns out that we cannot create a pci_driver in this driver because PCI will
> > not call this module's probe function if the i5000-edac driver is already
> > loaded.
> 
> I seem to recall work in progress to let multiple drivers bind to the
> same PCI device. Greg, Kay, what's the status?

Hannes provided me with a bunch of patches, some of which applied, some
didn't.  I had to back some of them out as they were wrong, and I need
to revisit them when I get a chance :(

thanks,

greg k-h
