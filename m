Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbZABV75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbZABV75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759574AbZABV7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:59:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:56937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759304AbZABV7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:59:38 -0500
From: Andreas Schwab <schwab@suse.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] linux/types.h: always export 64bit aligned defines
References: <1230885562-11456-1-git-send-email-vapier@gentoo.org>
	<je4p0hhjko.fsf@sykes.suse.de> <200901021547.32666.vapier@gentoo.org>
X-Yow: I know things about TROY DONAHUE that can't even be PRINTED!!
Date: Fri, 02 Jan 2009 22:59:35 +0100
In-Reply-To: <200901021547.32666.vapier@gentoo.org> (Mike Frysinger's message
	of "Fri, 2 Jan 2009 15:47:30 -0500")
Message-ID: <jer63lfjy0.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> writes:

> On Friday 02 January 2009 09:24:39 Andreas Schwab wrote:
>> Mike Frysinger <vapier@gentoo.org> writes:
>> > These these defines dont actually conflict with normal userspace / C
>> > library types, there's no reason to hide them behind the
>> > __KERNEL_STRICT_NAMES define.
>>
>> aligned_u64 would pollute the name space, wouldn't it?
>
> if by "pollute the name space" you mean "it'll be defined where it normally 
> wasnt before", then yes.

I mean that it may conflict with normal userspace which is the whole
point of being hidden.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
