Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbXEaMBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbXEaMBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759649AbXEaMBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:01:13 -0400
Received: from ns2.suse.de ([195.135.220.15]:53883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759590AbXEaMBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:01:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86_64 irq: check remote IRR bit before migrating level triggered irq (v2)
Date: Thu, 31 May 2007 14:01:02 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, nanhai.zou@intel.com,
       asit.k.mallick@intel.com, keith.packard@intel.com,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <20070517230324.GB8089@linux-os.sc.intel.com> <m1d50h5irm.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d50h5irm.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705311401.02221.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 May 2007 13:34:21 Eric W. Biederman wrote:
> 
> On x86_64 kernel, level triggered irq migration gets initiated in the context
> of that interrupt(after executing the irq handler) and following steps are
> followed to do the irq migration.

What's the confidence level in the patch? Is it a .22 candidate?

-Andi
