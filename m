Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZDVLbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZDVLbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZDVLau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:30:50 -0400
Received: from mga10.intel.com ([192.55.52.92]:55417 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511AbZDVLat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:30:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,230,1239001200"; 
   d="scan'208";a="450262316"
Message-ID: <49EEFFDE.3030105@linux.intel.com>
Date: Wed, 22 Apr 2009 13:30:38 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com>
In-Reply-To: <20090422101600.GL3226@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You may also want to consider to use the in-kernel ring_buffer api
> (include/linux/ring_buffer.h).

Its semantics don't map very well to the machine check requirements.

I did an analysis of that in http://thread.gmane.org/gmane.linux.kernel/772928/focus=773452
AFAIK the reasons stated there are all still valid.

-Andi

