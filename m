Return-Path: <linux-kernel-owner+w=401wt.eu-S1030221AbXBLWi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030221AbXBLWi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030216AbXBLWit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:38:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45994 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220AbXBLWiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:38:46 -0500
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2.6.21 review I] [11/25] x86: default to physical mode on hotplug CPU kernels
Date: Mon, 12 Feb 2007 23:36:23 +0100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <200702101250.142420000@suse.de> <20070210115023.D19ED13DCE@wotan.suse.de> <m1vei9ymkh.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1vei9ymkh.fsf@ebiederm.dsl.xmission.com>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702122336.23826.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 February 2007 12:13, Eric W. Biederman wrote:
> Andi Kleen <ak@suse.de> writes:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> >
> > Default to physical mode on hotplug CPU kernels.  Furher simplify and clean up
> > the APIC initialization code.
> 
> Where is the code that the subject describes?

True, that seems to be missing.

I agree that the patch seems to consist mostly of renaming doesn't make
it any easier to read.

And it's worrying that it doesn't handle the hotplug case at all.

> I have two problems here.
> 
> - I don't see anything handling the hotplug case, and forcing us to
>   physical mode.
> - Ingo's other patch asserts that hotplug should be made to handle
>   logical deliver mode.
> 
> With logical deliver mode the experimental evidence is that the
> destination cpu is a hint, 

What experimental evidence did you have? 

But I'm tempted to drop this unless the hotplug mystery can be cleared
up. There was past information that logical is unsafe for hotplug.

Ingo? Suresh? 

-Andi
