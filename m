Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXCTRE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXCTRE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965489AbXCTRE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:04:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:24255 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965456AbXCTRE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:04:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,305,1170662400"; 
   d="scan'208"; a="212841736:sNHT23475893"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] Export not_critical_when_idle feature in workqueue and use it in ondemand
Date: Tue, 20 Mar 2007 10:04:18 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F522F9B7@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070320145812.GB20671@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] Export not_critical_when_idle feature in workqueue and use it in ondemand
thread-index: AcdrADzgHFtS5xcSS+eUJDNxL5nyUgACkjHw
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Dave Jones" <davej@redhat.com>
Cc: "Andrew Morton" <akpm@osdl.org>, <tglx@linutronix.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Mar 2007 17:04:18.0942 (UTC) FILETIME=[CC4AD1E0:01C76B11]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Dave Jones [mailto:davej@redhat.com] 
>Sent: Tuesday, March 20, 2007 7:58 AM
>To: Pallipadi, Venkatesh
>Cc: Andrew Morton; tglx@linutronix.de; linux-kernel
>Subject: Re: [PATCH 2/2] Export not_critical_when_idle feature 
>in workqueue and use it in ondemand
>
>On Fri, Mar 16, 2007 at 03:09:03PM -0700, Venkatesh Pallipadi wrote:
> > 
> > 
> > Add a new not_critical_when_idle parameter to 
>queue_delayed_work_on(). This
> > parameter can be used to schedule work that are 'unimportant' when
> > CPU is idle and can be called later, when CPU eventually 
>comes out of idle.
> > 
> > Use this parameter in cpufreq ondemand governor.
> >  
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>
>just for kicks (actually because I was seeing the negative effects
>of not having this diff) I threw this in the Fedora devel kernel.
>Got a few people reporting softlockups during shutdown.
>jpeg from one user attached..
>

Thanks for the report. I will take a look at this message.
Looks like, this error is either coming from rmmod or changing the
governor to default from ondemand during reboot. Does Fedora
use ondemand as a module and rmmod on reboot or is it builtin?

Thanks,
Venki 
