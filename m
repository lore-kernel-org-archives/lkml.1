Return-Path: <linux-kernel-owner+w=401wt.eu-S933226AbXBWVs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbXBWVs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 16:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933227AbXBWVs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 16:48:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933226AbXBWVsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 16:48:55 -0500
Date: Fri, 23 Feb 2007 16:48:39 -0500
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jun Nakajima <jun.nakajima@intel.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RESEND 2/3] cpufreq_ondemand.c: don't use _WORK_NAR
Message-ID: <20070223214839.GA23768@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@tv-sign.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Jun Nakajima <jun.nakajima@intel.com>,
	David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
References: <20070223213506.GA441@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223213506.GA441@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 12:35:06AM +0300, Oleg Nesterov wrote:
 > Looks like dbs_timer() is very careful wrt per_cpu(cpu_dbs_info),
 > and it doesn't need the help of WORK_STRUCT_NOAUTOREL.
 > 
 > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
 > Acked-By: David Howells <dhowells@redhat.com>

This is sitting in cpufreq.git already.
I'll ask Linus to pull when he gets back.

		Dave

-- 
http://www.codemonkey.org.uk
