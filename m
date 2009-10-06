Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZJFUQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZJFUQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbZJFUQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:16:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:23120 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbZJFUQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:16:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,514,1249282800"; 
   d="scan'208";a="733597160"
From: "Kay, Allen M" <allen.m.kay@intel.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>
Date: Tue, 6 Oct 2009 13:15:54 -0700
Subject: RE: [PATCH ACS v3 1/1]
Thread-Topic: [PATCH ACS v3 1/1]
Thread-Index: AcpCNPS8MdEpINI1Q7SbW6/Glb9OjAD55rVg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E302232D@orsmsx505.amr.corp.intel.com>
References: <1253231193-5753-1-git-send-email-allen.m.kay@intel.com>
 <20090929000041.GB3958@sequoia.sous-sol.org>
 <57C9024A16AD2D4C97DC78E552063EA3E2EA3B70@orsmsx505.amr.corp.intel.com>
 <20090929184650.GF3958@sequoia.sous-sol.org>
 <57C9024A16AD2D4C97DC78E552063EA3E2F0411F@orsmsx505.amr.corp.intel.com>
 <20091001011721.GK3958@sequoia.sous-sol.org>
In-Reply-To: <20091001011721.GK3958@sequoia.sous-sol.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I was thinking that ACS could be enabled if an IOMMU is enabled.  Not a
> perfect fit, but seems reasonably close.

Chris, I'm working on a new version of the patch that incorporates iommu check.  I'm also adding a check for dom0 kernel as HW iommu is not visible to dom0.

Allen

-----Original Message-----
From: Chris Wright [mailto:chrisw@sous-sol.org] 
Sent: Wednesday, September 30, 2009 6:17 PM
To: Kay, Allen M
Cc: Chris Wright; linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; jbarnes@virtuousgeek.org; matthew@wil.cx
Subject: Re: [PATCH ACS v3 1/1]

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
