Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbYGRFaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbYGRFaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 01:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYGRFaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 01:30:13 -0400
Received: from ozlabs.org ([203.10.76.45]:50269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYGRFaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 01:30:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/8] cpumask: Replace cpumask_of_cpu with cpumask_of_cpu_ptr
Date: Fri, 18 Jul 2008 15:30:09 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Dave Jones <davej@codemonkey.org.uk>,
       Paul Jackson <pj@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Robert Richter <robert.richter@amd.com>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <20080715211429.629983000@polaris-admin.engr.sgi.com>
In-Reply-To: <20080715211429.629983000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807181530.10044.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2008 07:14:30 Mike Travis wrote:
>   * This patch replaces the dangerous lvalue version of cpumask_of_cpu
>     with new cpumask_of_cpu_ptr macros.  These are patterned after the
>     node_to_cpumask_ptr macros.

Hi Mike,

   Should we just put cpumask_of_cpu_map[] in generic code and then have 
cpumask_of_cpu() always return a cpumask_t pointer?  These macros which 
declare things which may be one of two types is a real penalty for code 
readability.

Thanks,
Rusty.
