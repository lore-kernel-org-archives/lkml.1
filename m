Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbXE2Nl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbXE2Nl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbXE2Nlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:41:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:1234 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbXE2Nls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:41:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,588,1170662400"; 
   d="scan'208";a="250720283"
Date: Tue, 29 May 2007 21:41:34 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH 2/2] [AGPGART] intel_agp: use table for device probe
Message-ID: <20070529134134.GA11026@zhen-devel.sh.intel.com>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
References: <20070529062125.GB5097@zhen-devel.sh.intel.com> <20070529091848.GB27950@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529091848.GB27950@infradead.org>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.29 10:18:48 +0000, Christoph Hellwig wrote:
> On Tue, May 29, 2007 at 02:21:25PM +0800, Wang Zhenyu wrote:
> > +static const struct intel_driver_description {
> > +	unsigned int chip_id;
> > +	unsigned int gmch_chip_id;
> > +	char *name;
> > +	struct agp_bridge_driver *driver;
> > +	struct agp_bridge_driver *gmch_driver;
> 
> The two should be const to avoid the silly casts below.
> 
> > +	for (i = 0; intel_agp_chipsets[i].name != NULL; i++) {
> > +		if (pdev->device == intel_agp_chipsets[i].chip_id)
> > +		    break;
> 
> please use tabs for indentation.
> 

I'll fix those problems in next submit, thank you for review. 
