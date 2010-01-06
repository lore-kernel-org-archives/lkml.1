Return-Path: <linux-kernel-owner+w=401wt.eu-S932085Ab0AFHQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab0AFHQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476Ab0AFHQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:16:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:49585 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab0AFHQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:16:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,226,1262592000"; 
   d="scan'208";a="761724027"
Subject: Re: [PATCH 4/5] ACPI, APEI, EINJ support
From: Huang Ying <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20100106070807.GA1494@ucw.cz>
References: <1261980744-4450-1-git-send-email-ying.huang@intel.com>
	 <1261980744-4450-2-git-send-email-ying.huang@intel.com>
	 <1261980744-4450-3-git-send-email-ying.huang@intel.com>
	 <1261980744-4450-4-git-send-email-ying.huang@intel.com>
	 <1261980744-4450-5-git-send-email-ying.huang@intel.com>
	 <20100106070807.GA1494@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 15:16:26 +0800
Message-ID: <1262762186.17852.7.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pavel,

On Wed, 2010-01-06 at 15:08 +0800, Pavel Machek wrote:
> On Mon 2009-12-28 14:12:23, Huang Ying wrote:
> > EINJ provides a hardware error injection mechanism, this is useful for
> > debugging and testing of other APEI and RAS features.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  drivers/acpi/apei/Kconfig  |    7 +
> >  drivers/acpi/apei/Makefile |    1 +
> >  drivers/acpi/apei/einj.c   |  471 ++++++++++++++++++++++++++++++++++++++++++++
> 
> 
> Can we get more meaningfull name? err_inject.c?

einj is the abbreviation used in ACPI specification. I think following
specification can avoid some confusion. Do you think so?

Best Regards,
Huang Ying


