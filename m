Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZGBQUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZGBQUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZGBQUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:20:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56472 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZGBQUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:20:35 -0400
Date: Thu, 2 Jul 2009 12:20:35 -0400
From: Dave Jones <davej@redhat.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jun Nakajima <jun.nakajima@intel.com>, cpufreq@vger.kernel.org
Subject: Re: 2.6.31-rc1-git9: INFO: possible circular locking dependency
	detected -- (&(&dbs_info->work)->work){+.+...}, at: [<c104292d>]
	__cancel_work_timer+0x81/0x17f
Message-ID: <20090702162035.GB21746@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Miles Lane <miles.lane@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Jun Nakajima <jun.nakajima@intel.com>, cpufreq@vger.kernel.org
References: <a44ae5cd0907020741g146cb2eq2f75a217fc3fad09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0907020741g146cb2eq2f75a217fc3fad09@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 10:41:23AM -0400, Miles Lane wrote:
 > [  348.243995] [ INFO: possible circular locking dependency detected ]
 > [  348.244004] 2.6.31-rc1-git9 #13
 > [  348.244009] -------------------------------------------------------
 > [  348.244017] pm-suspend/3134 is trying to acquire lock:
 > [  348.244023]  (&(&dbs_info->work)->work){+.+...}, at: [<c104292d>]
 > __cancel_work_timer+0x81/0x17f
 > [  348.244025]
 > [  348.244025] but task is already holding lock:
 > [  348.244025]  (dbs_mutex){+.+.+.}, at: [<f805791c>]
 > cpufreq_governor_dbs+0x1fd/0x279 [cpufreq_ondemand]

well known by now. Venki is working on a fix, but it's not a simple
fix, so it's taking time.

	Dave
