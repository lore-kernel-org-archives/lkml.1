Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbZLPRFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbZLPRFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZLPRFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:05:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:3373 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbZLPRFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:05:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,407,1257148800"; 
   d="scan'208";a="756777505"
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
From: reinette chatre <reinette.chatre@intel.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: Greg KH <greg@kroah.com>, "John W. Linville" <linville@tuxdriver.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Winkler, Tomas" <tomas.winkler@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>, "Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <4B288232.4060901@canonical.com>
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>
	 <1260848710-5650-1-git-send-email-ike.pan@canonical.com>
	 <20091215041500.GB31200@kroah.com> <4B273479.6050502@canonical.com>
	 <20091215134943.GA11667@kroah.com> <20091215163100.GC8097@tuxdriver.com>
	 <1260906168.9623.4.camel@rc-desk> <20091215194938.GA13297@kroah.com>
	 <4B288232.4060901@canonical.com>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 09:05:01 -0800
Message-Id: <1260983101.9623.11.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 22:46 -0800, Ike Panhc wrote:

> But Please consider applying the first patch (change IWL6000_UCODE_API_MAX
> to v4) to 2.6.31-stable tree. It will be good to use v4 firmware on iwl6000.

Please no. This will effectively enable 6000 series in 2.6.31. We did
not target 2.6.31 for 6000 series enabling and more patches, which are
in 2.6.32, are required for 6000 series to work well.

Reinette

