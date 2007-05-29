Return-Path: <linux-kernel-owner+w=401wt.eu-S1763988AbXE2JS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763988AbXE2JS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 05:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbXE2JSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 05:18:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44981 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbXE2JSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 05:18:49 -0400
Date: Tue, 29 May 2007 10:18:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH 2/2] [AGPGART] intel_agp: use table for device probe
Message-ID: <20070529091848.GB27950@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
References: <20070529062125.GB5097@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529062125.GB5097@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 02:21:25PM +0800, Wang Zhenyu wrote:
> +static const struct intel_driver_description {
> +	unsigned int chip_id;
> +	unsigned int gmch_chip_id;
> +	char *name;
> +	struct agp_bridge_driver *driver;
> +	struct agp_bridge_driver *gmch_driver;

The two should be const to avoid the silly casts below.

> +	for (i = 0; intel_agp_chipsets[i].name != NULL; i++) {
> +		if (pdev->device == intel_agp_chipsets[i].chip_id)
> +		    break;

please use tabs for indentation.

