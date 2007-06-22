Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXFVA5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXFVA5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 20:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbXFVA5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 20:57:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:20639 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbXFVA5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 20:57:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,449,1175497200"; 
   d="scan'208";a="259783649"
Date: Fri, 22 Jun 2007 08:55:53 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Carlo Wood <carlo@alinoe.com>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, eric@anholt.net
Subject: Re: [PATCH][AGPGART] intel_agp: don't load if no IGD and AGP port
Message-ID: <20070622005553.GB13351@zhen-devel.sh.intel.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net
References: <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org> <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com> <20070620011521.GB2856@zhen-devel.sh.intel.com> <20070620014227.GA4090@zhen-devel.sh.intel.com> <20070620140237.GB5524@alinoe.com> <20070620154610.GA2802@localhost.localdomain> <20070621054318.GA31381@zhen-devel.sh.intel.com> <20070621161050.GA5285@alinoe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621161050.GA5285@alinoe.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.21 18:10:50 +0000, Carlo Wood wrote:
> 
> I am glad to see that you found a real reason for why it might have
> gone wrong. Just not initializing because it's not needed, but not
> understanding WHY it went wrong would have been rather unsatisfactory.
> 

yes, I understand, but it looks we did the wrong thing in the first step,
so... Thanks for testing this!
