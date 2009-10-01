Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbZJABRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbZJABRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 21:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZJABRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 21:17:23 -0400
Received: from sous-sol.org ([216.99.217.87]:57563 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755300AbZJABRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 21:17:23 -0400
Date: Wed, 30 Sep 2009 18:17:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Kay, Allen M" <allen.m.kay@intel.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>
Subject: Re: [PATCH ACS v3 1/1]
Message-ID: <20091001011721.GK3958@sequoia.sous-sol.org>
References: <1253231193-5753-1-git-send-email-allen.m.kay@intel.com> <20090929000041.GB3958@sequoia.sous-sol.org> <57C9024A16AD2D4C97DC78E552063EA3E2EA3B70@orsmsx505.amr.corp.intel.com> <20090929184650.GF3958@sequoia.sous-sol.org> <57C9024A16AD2D4C97DC78E552063EA3E2F0411F@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E2F0411F@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kay, Allen M (allen.m.kay@intel.com) wrote:
> On the other hand, can we say VT-d PT mode is mainly for KVM
> virtualization use case?  If so, is it reasonable to say performance of
> host P2P in this mode is not of highest priority?

Guess it depends on the workload.  Would be helpful to identify a use
case that is p2p heavy (and then the impact of enabling ACS).

> If not, another option is to have a kernel boot parameter to
> configure an kernel boot instance to be either host kernel optimized or
> virtualization optimized.  I don't know whether this is a reasonable or
> not ...

I was thinking that ACS could be enabled if an IOMMU is enabled.  Not a
perfect fit, but seems reasonably close.

thanks,
-chris
