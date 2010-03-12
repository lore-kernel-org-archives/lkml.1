Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0CLDWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 22:22:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:12989 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab0CLDWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 22:22:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,624,1262592000"; 
   d="scan'208";a="500035527"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 0 of 5] PV on HVM Xen
Date: Fri, 12 Mar 2010 11:23:33 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
References: <alpine.DEB.2.00.1003101457100.28412@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003101457100.28412@kaball-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003121123.33935.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 March 2010 23:46:54 Stefano Stabellini wrote:
> Hi all,

Stefano,

And next time when you send out the patch, please be more respect to my work.

You dropped all the original author(me) of patchset, and only add a sign-off 
for me. If you don't aware the difference, here is a snippet of 
linux/Documentation/SummittingPatches

532 The "from" line must be the very first line in the message body,
533 and has the form:
534
535         From: Original Author <author@example.com>
536
537 The "from" line specifies who will be credited as the author of the
538 patch in the permanent changelog.  If the "from" line is missing,
539 then the "From:" line from the email header will be used to determine
540 the patch author in the changelog.

As you see, the first two kernel patches of mine contained file from Jeremy 
and Keir, and I add the "From" for them properly to respect their works.

Another thing is, you were keeping using my old patches as your base, while I 
was working with the reviewers to update the patch quickly. I don't think 
that's a kind of respect to both reviewers' and my work. You would duplicate 
reviewer's effect, especially you always repost the whole patch(and drop my 
authorship) rather than the different part. I've split patches in order to 
provide a code base for further development, but you complete ignored them and 
keeping post the whole patchset based on my old patches.

Please be more professional. Thanks.

-- 
regards
Yang, Sheng

> this is a reduced and rebased version of the patch series I sent
> yesterday "enhanced PV on HVM": this series is based on Linux 2.5.32 and
> can be applied now, it includes everything but the pirq remapping
> related functions that are not ready to be upstreamed at the moment.
> 
> Therefore it just achieves the goal of enabling PV devices in Linux
> running in a Xen HVM domain, it doesn't allow event channels delivery in
> place of interrupts.
> 
> The patch series consists of 5 patches, each patch comes with a detailed
> description.
> In order for this to work we also need a patch for Xen, that is being
> worked on as we speak.
> 
> Any comment, critic or suggestion is very welcome.
> 
> Cheers,
> 
> Stefano
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
> 
