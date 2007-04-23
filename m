Return-Path: <linux-kernel-owner+w=401wt.eu-S964792AbXDWQDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbXDWQDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964934AbXDWQDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:03:16 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964792AbXDWQDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:03:16 -0400
Message-ID: <462CD877.8000302@zytor.com>
Date: Mon, 23 Apr 2007 09:01:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org>	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org> <m1d51vxxm4.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d51vxxm4.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> I happened to be looking at this stretch of code and I have realized
> that this is quite simply the wrong fix.
> 
> The problem is that it depends intimately on the details of
> alloc_bootmem_pages_low.  Essentially the problem is that when
> we are setting up the identity mappings in paging_init we assume
> the identity mappings already exist.
> 
> If there are holes in the memory map or someone changes the way
> pages are returned from alloc_bootmem_pages_low() this code
> will break again.
> 

How would holes in the memory map affect it?

	-hpa
