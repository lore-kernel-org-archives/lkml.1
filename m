Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbZBFCek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbZBFCek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZBFCe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:34:28 -0500
Received: from mga14.intel.com ([143.182.124.37]:51972 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZBFCe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:34:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,389,1231142400"; 
   d="scan'208";a="107766109"
Subject: Re: [PATCH v2] NOHZ: fix nohz on cpu unplug
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Ingo Molnar <mingo@elte.hu>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <498B43D9.2080800@rtr.ca>
References: <200901301729.30284.borntraeger@de.ibm.com>
	 <200902030948.13519.borntraeger@de.ibm.com>
	 <20090203122847.GG19979@elte.hu>
	 <200902040719.25593.borntraeger@de.ibm.com>
	 <1233777584.16238.16.camel@vayu> <20090204213202.GP22608@elte.hu>
	 <498B43D9.2080800@rtr.ca>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 05 Feb 2009 18:33:27 -0800
Message-Id: <1233887607.16238.47.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 11:54 -0800, Mark Lord wrote:
> How far back in (kernel release) time does this problem exist?
> Candidate for -stable ?

Problem is present for a while now. But I don't think this is a common
case scenario (as the issue happens only for the duration when we leave
a cpu offline, and it should get fixed the moment that logical cpu is
back online).

thanks,
suresh

