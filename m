Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZIRH35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZIRH35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZIRH35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:29:57 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:13608 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950AbZIRH34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:29:56 -0400
X-Trace: 263037349/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.69.67/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.69.67
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEABLUskpQKUVD/2dsb2JhbACBUtJshBwFgVg
X-IronPort-AV: E=Sophos;i="4.44,408,1249254000"; 
   d="scan'208";a="263037349"
Date: Fri, 18 Sep 2009 08:29:09 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>
Subject: Re: aim7 scalability issue on 4 socket machine
In-Reply-To: <20090918071217.GB17634@basil.fritz.box>
Message-ID: <Pine.LNX.4.64.0909180822080.3935@sister.anvils>
References: <1253179879.2606.37.camel@ymzhang> <1253180411.8497.1.camel@twins>
 <Pine.LNX.4.64.0909171122180.25864@sister.anvils> <1253239339.2606.40.camel@ymzhang>
 <20090917195909.3a00ef83.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0909180742500.14561@sister.anvils> <20090918071217.GB17634@basil.fritz.box>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Andi Kleen wrote:
> 
> So yes I think simple non intrusive fixes for serious scalability
> problems should be stable candidates.

This one is certainly non-intrusive, and you're all in agreement
that it better go in, so I won't dispute that.

(But I'm a little worried that this easily fixed issue will turn out
to be just the first in a string of not so easily fixed issues.)

Hugh
