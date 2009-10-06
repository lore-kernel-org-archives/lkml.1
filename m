Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbZJFX7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbZJFX7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbZJFX7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:59:04 -0400
Received: from sous-sol.org ([216.99.217.87]:55918 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758364AbZJFX7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:59:02 -0400
Date: Tue, 6 Oct 2009 16:58:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Allen Kay <allen.m.kay@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, matthew@wil.cx,
       chrisw@sous-sol.org, jeremy@goop.org
Subject: Re: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding
Message-ID: <20091006235823.GC23140@sequoia.sous-sol.org>
References: <1254861226-18376-1-git-send-email-allen.m.kay@intel.com> <20091006234208.GB23140@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006234208.GB23140@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Wright (chrisw@sous-sol.org) wrote:
> * Allen Kay (allen.m.kay@intel.com) wrote:
> > +#ifdef CONFIG_XEN
> > +	/* HW iommu is not visible in xen dom0 */
> > +	if (xen_domain_type)
> > +		pci_enable_acs(dev);
> 
> could do this (xen_initial_domain()) above, but it's only relevant for
> dom0 (so not needed yet?), and really seems to like it should be done by hv.

Guess it doesn't matter since dom0 could just as easily undo it, so
nevermind on the hv bit ;-)
