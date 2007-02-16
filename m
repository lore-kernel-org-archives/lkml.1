Return-Path: <linux-kernel-owner+w=401wt.eu-S1750828AbXBPLLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750828AbXBPLLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 06:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbXBPLLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 06:11:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41034 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbXBPLLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 06:11:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: vatsa@in.ibm.com
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Date: Fri, 16 Feb 2007 12:06:39 +0100
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Gautham R Shenoy <ego@in.ibm.com>,
       akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
References: <20070214144031.GA15257@in.ibm.com> <200702161029.21560.rjw@sisk.pl> <20070216095930.GA21501@in.ibm.com>
In-Reply-To: <20070216095930.GA21501@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161206.40483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 16 February 2007 10:59, Srivatsa Vaddagiri wrote:
> On Fri, Feb 16, 2007 at 10:29:20AM +0100, Rafael J. Wysocki wrote:
> > Well, the suspend code has been developed with the assumption that frozen
> > threads stay frozen until _we_ let them thaw by calling thaw_processes().  I'm
> > a bit afraid of this change.
> 
> Note that only kernel threads created thr' kthread_create are allowed
> to exit like this from the refrigerator, that too only when
> (kthread_stop_info.k == current). So all other threads should be unaffected
> because of this change.

Yes, that's why I said "a bit". ;-)
