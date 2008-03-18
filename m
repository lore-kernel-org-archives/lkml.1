Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbYCRAOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbYCRAOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 20:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYCRAO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 20:14:28 -0400
Received: from lixom.net ([66.141.50.11]:55832 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbYCRAOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 20:14:19 -0400
Date: Mon, 17 Mar 2008 19:21:31 -0500
From: Olof Johansson <olof@lixom.net>
To: "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org, pasemi-linux@ozlabs.org,
       linuxppc-dev@ozlabs.org, hskinnemoen@atmel.com
Subject: Re: [PATCH v2] pasemi_dma: Driver for PA Semi PWRficient on-chip
	DMAengine
Message-ID: <20080318002131.GA382@lixom.net>
References: <20080306233900.GA3969@lixom.net> <20080316213002.GA2589@lixom.net> <BAE9DCEF64577A439B3A37F36F9B691C043E6716@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C043E6716@orsmsx418.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 17, 2008 at 01:34:05PM -0700, Nelson, Shannon wrote:

> In the future please copy Maciej as one of "the DMA guys" as he has
> taken over ioatdma for me.  Beyond that, one little picky comment
> below...

Time to set up a list, or have everyone monitor lkml, I'd say. I'd
prefer the former.

> >+static unsigned int channels = 4;
> >+module_param(channels, uint, S_IRUGO);
> >+MODULE_PARM_DESC(channels, "Number of channels for copy 
> >(default: 2)");
> 
> Is the number of channels defaulting to 2 or 4?

Ah, yes, good catch.


-Olof
