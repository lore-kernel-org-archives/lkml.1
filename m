Return-Path: <linux-kernel-owner+w=401wt.eu-S936156AbXHHQY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936156AbXHHQY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934452AbXHHQXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:23:50 -0400
Received: from ns.suse.de ([195.135.220.2]:60577 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936009AbXHHQXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:23:49 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "huang ying" <huang.ying.caritas@gmail.com>
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
Date: Wed, 8 Aug 2007 18:23:44 +0200
User-Agent: KMail/1.9.6
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Chandramouli Narayanan" <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <9D7649D18729DE4BB2BD7B494F7FEDC246DC2B@pdsmsx415.ccr.corp.intel.com> <200708081609.33098.ak@suse.de> <851fc09e0708080811l1e17255ctef617d9137a8c045@mail.gmail.com>
In-Reply-To: <851fc09e0708080811l1e17255ctef617d9137a8c045@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081823.44324.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007 17:11:54 huang ying wrote:
> On 8/8/07, Andi Kleen <ak@suse.de> wrote:
> > > Instead, elilo collects the needed information
> > > defined in include/asm-x86_64/bootsetup.h itself,
> >
> > That's nasty. I must have missed when we declared this a public ABI.
> > It's not really designed to be one. Was there public discussion on this?
> 
> Maybe What I said is not clear and correct. In fact, the elilo follows
> the boot protocol defined in Documentation/i386/zero-page.txt, 

No that's not the boot protocol. The boot protocol is in Documentation/i386/boot.txt

> just 
> not uses arch/(i386|x86_64)/boot/setup.S to collect the information,
> but collects them by elilo itself. Information in
> include/asm-x86_64/bootsetup.h is just a part of that in
> Documentation/i386/zero-page.txt.

That's an internal interface that is not really suitable to use
by other programs. e.g. it is not extensible (unlike the boot protocol) 

-Andi
