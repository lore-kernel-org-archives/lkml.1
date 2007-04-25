Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbXDYVbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbXDYVbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbXDYVbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:31:22 -0400
Received: from gw.goop.org ([64.81.55.164]:59101 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbXDYVbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:31:22 -0400
Message-ID: <462FC8CD.1030505@goop.org>
Date: Wed, 25 Apr 2007 14:31:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Chuck Ebbert <cebbert@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org>	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org> <m1abwwqiof.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abwwqiof.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy did your kernel have PAE enabled?
>
> It just occurred to me that we have at all of the memory below 1M (say about
> 512K) mapped and available to setup new mappings.
>
> The only way I can see a page fault happening is if you were using a PAE
> enabled kernel (so you were not updating the current page tables) and
> you have more than 256M of low memory, and we don't get any much extra
> from always mapping 4M at a time.

Yes, that's the situation.  PAE enabled, ~768MB of memory and a large
kernel which mostly fills the 8M mapping.

    J
