Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZHFPDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZHFPDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZHFPDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:03:41 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:20539 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbZHFPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:03:41 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Shaohua Li <shaohua.li@intel.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>, Balbir Singh <balbir@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090806043351.GC14333@dirshya.in.ibm.com>
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com>
	 <20090806015855.GA20596@sli10-desk.sh.intel.com>
	 <20090806043351.GC14333@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 17:03:18 +0200
Message-Id: <1249570998.32113.499.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 10:03 +0530, Vaidyanathan Srinivasan wrote:
> This was the
> main objection to Venki's deepest sleep state for offline cpus patch.

Well, my main objection was that is was a single raw function pointer
without any management layer around it.

We have the exact same mess with the idle routine - and that has bitten
us in the past.

