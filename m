Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbXBNPg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbXBNPg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 10:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932336AbXBNPg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 10:36:56 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44950 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341AbXBNPgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 10:36:55 -0500
Date: Wed, 14 Feb 2007 21:01:42 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       oleg@tv-sign.ru, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070214153142.GB5200@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214144229.GA19789@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 08:12:29PM +0530, Gautham R Shenoy wrote:
> o Can the SYSTEM_RUNNING hack in _cpu_up be avoided by some cleaner means.

Basically freeze_processes doesnt seem to work at the early stages of
bootup (during smp_init) and hence the hack.

One option is to investigate why it didnt work and possibly make it work
at that early stage as well ..


-- 
Regards,
vatsa
