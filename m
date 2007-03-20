Return-Path: <linux-kernel-owner+w=401wt.eu-S965544AbXCTRQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544AbXCTRQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965529AbXCTRQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:16:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965544AbXCTRQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:16:58 -0400
Date: Tue, 20 Mar 2007 13:16:48 -0400
From: Dave Jones <davej@redhat.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@osdl.org>, tglx@linutronix.de,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Export not_critical_when_idle feature in workqueue and use it in ondemand
Message-ID: <20070320171648.GB19781@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Andrew Morton <akpm@osdl.org>, tglx@linutronix.de,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20070320145812.GB20671@redhat.com> <653FFBB4508B9042B5D43DC9E18836F522F9B7@scsmsx415.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F522F9B7@scsmsx415.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 10:04:18AM -0700, Pallipadi, Venkatesh wrote:

 > >just for kicks (actually because I was seeing the negative effects
 > >of not having this diff) I threw this in the Fedora devel kernel.
 > >Got a few people reporting softlockups during shutdown.
 > >jpeg from one user attached..
 > 
 > Thanks for the report. I will take a look at this message.
 > Looks like, this error is either coming from rmmod or changing the
 > governor to default from ondemand during reboot. Does Fedora
 > use ondemand as a module and rmmod on reboot or is it builtin?

Yes, it's modular.

	Dave

-- 
http://www.codemonkey.org.uk
