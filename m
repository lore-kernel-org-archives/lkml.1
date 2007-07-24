Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbXGXPTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbXGXPTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXGXPTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:19:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55457 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbXGXPTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:19:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Tue, 24 Jul 2007 17:27:34 +0200
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Machek" <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       "Kexec Mailing List" <kexec@lists.infradead.org>
References: <9D7649D18729DE4BB2BD7B494F7FEDC236CF66@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <9D7649D18729DE4BB2BD7B494F7FEDC236CF66@pdsmsx415.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241727.35589.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 July 2007 16:00, Huang, Ying wrote:
> >From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> >This is not the point.  There are memory regions that you should not
> _restore_,
> >because that will cause harm.
> >
> >> On x86_64, there is another usage of nosave during processing E820
> >> memory map. But I don't know why the memory region other than
> E820_RAM
> >> are marked as nosave. I think only the memory region of type E820_RAM
> >> will be thought of normal memory, others will be thought as reserved.
> Is
> >> it sufficient just to check whether the page is reserved?
> >
> >No, it's not.
> 
> The "/proc/iomem" records information of all memory regions including
> "normal RAM" and all kinds of reserved regions, which is backed by
> iomem_resource. On x86_64, it is initialized in the exact same way as
> nosave region initialization.
> 
> I think maybe we can replace the "nosave region" concepts with
> "iomem_resource" (maybe need some enhancement).

Yes, I think that might be done.

Geetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
