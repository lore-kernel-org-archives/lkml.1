Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbXCUWFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbXCUWFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbXCUWFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:05:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809AbXCUWFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:05:04 -0400
Date: Wed, 21 Mar 2007 18:04:56 -0400
From: Dave Jones <davej@redhat.com>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de
Subject: Re: [PATCH 2/2] Export deferrable timer through workqueue and use it in ondemand governor
Message-ID: <20070321220456.GA3796@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Andrew Morton <akpm@osdl.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
References: <20070321202339.GB29367@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321202339.GB29367@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 01:23:40PM -0700, Venkatesh Pallipadi wrote:
 > 
 > 
 > Add a new deferrable delayed work init. This can be used to schedule work
 > that are 'unimportant' when CPU is idle and can be called later, when CPU
 > eventually comes out of idle.
 > 
 > Use this init in cpufreq ondemand governor.
 >  
 > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

drivers/cpufreq/cpufreq_ondemand.c: In function 'dbs_timer_init':
drivers/cpufreq/cpufreq_ondemand.c:473: error: implicit declaration of function 'init_timer_deferrable'

	Dave

-- 
http://www.codemonkey.org.uk
