Return-Path: <linux-kernel-owner+w=401wt.eu-S965620AbXCBVCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620AbXCBVCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965621AbXCBVCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:02:38 -0500
Received: from mga06.intel.com ([134.134.136.21]:44845 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965620AbXCBVCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:02:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,244,1170662400"; 
   d="scan'208"; a="203418982:sNHT21197358"
Subject: system call time increase when turning on CONFIG_PARAVIRT
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Intel
Date: Fri, 02 Mar 2007 12:11:14 -0800
Message-Id: <1172866274.4898.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With CONFIG_PARAVIRT turned on, I've found that time invoking
system_call jumped up quite a lot.  Using TCP streaming test as a
workload and running on 32-bit 2.6.20 kernel, system_call goes up from
0.00025% all the way to 1.6% in the oprofile data.  There is a drop of
about 4% in overall throughput for this particular workload. 

With lmbench's null system call test, the call time goes up from 0.10
usec to 0.225 usec.

I'm testing on dual socket Intel core 2 processor running at 2.67 GHz
with 4 GB RAM.

Tim 
