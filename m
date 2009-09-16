Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbZIPNpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbZIPNpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZIPNpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:45:42 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:44095 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZIPNpm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Sep 2009 09:45:42 -0400
Date: Wed, 16 Sep 2009 09:31:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eddie Dong <eddie.dong@intel.com>, linux-kernel@vger.kernel.org,
       Jun Nakajima <jun.nakajima@intel.com>
Subject: Re: [Xen-devel] [RFC][PATCH 0/10] Xen Hybrid extension support
Message-ID: <20090916133104.GB14725@phenom.dumpdata.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AB0EC00.0144:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 04:42:21PM +0800, Sheng Yang wrote:
> Hi, Keir & Jeremy
> 
> This patchset enabled Xen Hybrid extension support.
> 
> As we know that PV guest have performance issue with x86_64 that guest kernel
> and userspace resistent in the same ring, then the necessary TLB flushes when
> switch between guest userspace and guest kernel cause overhead, and much more
> syscall overhead is also introduced. The Hybrid Extension estimated these
> overhead by putting guest kernel back in (non-root) ring0 then achieve the better
> performance than PV guest.

What was the overhead? Is there a step-by-step list of operations you did
to figure out the performance numbers? 

I am asking this b/c at some point I would like to compare the pv-ops vs native
and I am not entirely sure what is the best way to do this.

