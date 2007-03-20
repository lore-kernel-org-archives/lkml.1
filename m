Return-Path: <linux-kernel-owner+w=401wt.eu-S1751555AbXCTXxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbXCTXxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXCTXxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:53:00 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38193 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbXCTXw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:52:58 -0400
Date: Tue, 20 Mar 2007 16:51:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jeremy@goop.org,
       xen-devel@lists.xensource.com, netdev@vger.kernel.org, mingo@elte.hu,
       jbeulich@novell.com, virtualization@lists.linux-foundation.org,
       chrisw@sous-sol.org, virtualization@lists.osdl.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, anthony@codemonkey.ws,
       akpm@linux-foundation.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [patch 13/26] Xen-paravirt_ops: Consistently
 wrap paravirt ops callsites to make them patchable
In-Reply-To: <20070320214945.GG4286@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0703201644490.6730@woody.linux-foundation.org>
References: <200703201428.50564.ak@suse.de> <m1ircvswzz.fsf@ebiederm.dsl.xmission.com>
 <20070320174159.GA4286@bingen.suse.de> <Pine.LNX.4.64.0703200947501.6730@woody.linux-foundation.org>
 <20070320180359.GB4286@bingen.suse.de> <Pine.LNX.4.64.0703201022040.6730@woody.linux-foundation.org>
 <20070320192118.GD4286@bingen.suse.de> <Pine.LNX.4.64.0703201145570.6730@woody.linux-foundation.org>
 <20070320202352.GF4286@bingen.suse.de> <20070320213918.116862be@lxorguk.ukuu.org.uk>
 <20070320214945.GG4286@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Mar 2007, Andi Kleen wrote:
> 
> Linus is worried about the unwinder crashing -- that wouldn't help with that.

And to make it clear: this is not a theoretical worry. It happened many 
times over the months the unwinder was in. 

It was supposed to help debugging, but it made bugs that *would* have been 
nicely debuggable without it into nightmares. So the only reason for it 
existing in the first place was actually the thing that made it not work.

		Linus
