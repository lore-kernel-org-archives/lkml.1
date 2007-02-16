Return-Path: <linux-kernel-owner+w=401wt.eu-S1945929AbXBPJ7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945929AbXBPJ7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945930AbXBPJ7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:59:39 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37553 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945929AbXBPJ7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:59:39 -0500
Date: Fri, 16 Feb 2007 15:29:30 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Gautham R Shenoy <ego@in.ibm.com>,
       akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070216095930.GA21501@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070216071617.GB4527@in.ibm.com> <20070216081209.GB2829@in.ibm.com> <200702161029.21560.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702161029.21560.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 10:29:20AM +0100, Rafael J. Wysocki wrote:
> Well, the suspend code has been developed with the assumption that frozen
> threads stay frozen until _we_ let them thaw by calling thaw_processes().  I'm
> a bit afraid of this change.

Note that only kernel threads created thr' kthread_create are allowed
to exit like this from the refrigerator, that too only when
(kthread_stop_info.k == current). So all other threads should be unaffected
because of this change.

-- 
Regards,
vatsa
