Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZJNSgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZJNSgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZJNSgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:36:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:58899 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbZJNSgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:36:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,560,1249282800"; 
   d="scan'208";a="457464402"
From: "Luck, Tony" <tony.luck@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "mingo@redhat.com" <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "cebbert@redhat.com" <cebbert@redhat.com>
Date: Wed, 14 Oct 2009 11:36:07 -0700
Subject: RE: [PATCH 13/16] percpu: remove per_cpu__ prefix.
Thread-Topic: [PATCH 13/16] percpu: remove per_cpu__ prefix.
Thread-Index: AcpM/EN9Te4+fY0MTD+Sr05+7vcMiwAAF2aw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E3226704@orsmsx505.amr.corp.intel.com>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
 <1255500125-3210-14-git-send-email-tj@kernel.org>
 <alpine.DEB.1.10.0910141026370.26476@gentwo.org>
 <57C9024A16AD2D4C97DC78E552063EA3E32264A8@orsmsx505.amr.corp.intel.com>
 <alpine.DEB.1.10.0910141420300.9708@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910141420300.9708@gentwo.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> we would still have to use per cpu operations to get to the contents of
> these variables.

That's good.

> Hope that addresses your concerns.

But then I don't understand the original patch that was going to do:

> -#define __ia64_per_cpu_var(var)	per_cpu__##var
> +#define __ia64_per_cpu_var(var)	var

Presumably all actual use of __ia64_per_cpu_var is being replaced
by some other "per cpu operations"?

-Tony

