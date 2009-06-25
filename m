Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZFYRiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZFYRiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZFYRiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:38:06 -0400
Received: from kroah.org ([198.145.64.141]:57243 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbZFYRiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:38:05 -0400
Date: Thu, 25 Jun 2009 10:33:55 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>, tj@kernel.org, hancockr@shaw.ca,
       alan@lxorguk.ukuu.org.uk, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, daniel.ritz@gmx.ch,
       linux@dominikbrodowski.net, kaneshige.kenji@jp.fujitsu.com,
       towerlexa@gmx.de, benh@kernel.crashing.org, mingo@elte.hu,
       tglx@linutronix.de, tony.luck@intel.com
Subject: Re: [RFC PATCH 1/2] pci: determine CLS more intelligently
Message-ID: <20090625173355.GA4847@kroah.com>
References: <4A43234D.9050608@kernel.org> <20090625.020507.203808859.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625.020507.203808859.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 02:05:07AM -0700, David Miller wrote:
> From: Tejun Heo <tj@kernel.org>
> Date: Thu, 25 Jun 2009 16:12:13 +0900
> 
> > sparc64 is currently the only one using PCI_CACHE_LINE_BYTES.
> 
> Feel free to add the patch below and:
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> 
> Although I think it's better to declare pci_dfl_cache_line_size in
> linux/pci.h instead of making every arch do the extern decl.

I agree, that would make more sense.

Otherwise it looks good to me:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
