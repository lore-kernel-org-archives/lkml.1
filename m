Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbXEXV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbXEXV5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXEXV4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:56:45 -0400
Received: from ns1.suse.de ([195.135.220.2]:59044 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbXEXV4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:56:44 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Date: Thu, 24 May 2007 23:56:39 +0200
User-Agent: KMail/1.9.6
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20070523224637.GB15887@linux-os.sc.intel.com> <200705242325.28011.ak@suse.de> <20070524212806.GA5249@linux-os.sc.intel.com>
In-Reply-To: <20070524212806.GA5249@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705242356.39385.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I can do it in intel setup function. But, the feature may not be activated
> unless the driver is loaded.

That would put users in a chicken and egg situation: they cannot know they
need to load a driver to go faster. It's better to display it always.

-Andi
