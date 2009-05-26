Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZEZRs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZEZRs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZEZRst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:48:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:32719 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZEZRst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:48:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,253,1241420400"; 
   d="scan'208";a="415783971"
Subject: Re: [PATCH] NOHZ: Properly feed cpufreq ondemand governor
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: "ext-eero.nurkkala@nokia.com" <ext-eero.nurkkala@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <4A1C0818.3010003@redhat.com>
References: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com>
	 <4A1C0818.3010003@redhat.com>
Content-Type: text/plain
Date: Tue, 26 May 2009 10:47:29 -0700
Message-Id: <1243360049.4534.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 08:17 -0700, Rik van Riel wrote:
> ext-eero.nurkkala@nokia.com wrote:
> > From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
> > 
> > A call from irq_exit() may occasionally pause the timing
> > info for cpufreq ondemand governor. This results in the
> > cpufreq ondemand governor to fail to calculate the 
> > system load properly. Thus, relocate the checks for this
> > particular case to keep the governor always functional.
> > 
> > Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
> > Reported-by: Tero Kristo <tero.kristo@nokia.com>
> 
> Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

