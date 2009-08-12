Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZHLSUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZHLSUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZHLSUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:20:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35719 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZHLSUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:20:16 -0400
Date: Wed, 12 Aug 2009 20:20:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Wang, Shane" <shane.wang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [RFC v6][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
	Technology support for Linux - Details
Message-ID: <20090812182013.GJ28848@basil.fritz.box>
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu> <20090812145321.GA11347@elte.hu> <4A82DBA2.2000509@zytor.com> <037F493892196B458CD3E193E8EBAD4F01EAB641FD@pdsmsx502.ccr.corp.intel.com> <4A82ED93.70705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A82ED93.70705@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The question is: if the user doesn't want S3, do they still need to
> enable S3 in order to be able to use TXT?  Otherwise, this code needs to
> be properly conditionalized.

I doubt that's the case. Ifdef is likely the right answer.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
