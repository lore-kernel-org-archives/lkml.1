Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbZJNHm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbZJNHm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbZJNHm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:42:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:58821 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbZJNHmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:42:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,556,1249282800"; 
   d="scan'208";a="198738234"
Subject: Re: linux-next: manual merge of the pci tree with Linus' tree
From: David Woodhouse <david.woodhouse@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>
In-Reply-To: <20091014110532.f543b915.sfr@canb.auug.org.au>
References: <20091014110532.f543b915.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Wed, 14 Oct 2009 08:41:46 +0100
Message-Id: <1255506106.4523.79.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 01:05 +0100, Stephen Rothwell wrote:
> ++device_initcall(pci_init); 

That puts it _after_ some device drivers have already started up.
Possibly not what was intended?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

