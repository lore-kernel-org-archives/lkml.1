Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZBLDP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZBLDP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 22:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbZBLDPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 22:15:16 -0500
Received: from ns1.suse.de ([195.135.220.2]:37561 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbZBLDPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 22:15:15 -0500
From: "NeilBrown" <neilb@suse.de>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Date: Thu, 12 Feb 2009 14:15:06 +1100 (EST)
Message-ID: <6f6ef82b3d3f7eb8445e2e40ce3b534d.squirrel@neil.brown.name>
In-Reply-To: <1234407151.5566.21.camel@brick>
References: <1234401418.5566.19.camel@brick>
    <2540bee2375afb6f08eb92d19e7a1bf0.squirrel@neil.brown.name>
    <1234407151.5566.21.camel@brick>
Subject: Re: [PATCH] nfs: replace uses of __constant_{endian}
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, February 12, 2009 1:52 pm, Harvey Harrison wrote:
> On Thu, 2009-02-12 at 13:50 +1100, NeilBrown wrote:
>> On Thu, February 12, 2009 12:16 pm, Harvey Harrison wrote:
>> > The base versions handle constant folding now, none of these headers
>> > are exported to userspace, so the __ prefixed versions are not
>> > necessary.
>>
>> I assume you compile tested this?
>>
>> I seem to recall that the reason we did it that way was that
>> some of the error codes are used in switch statements, and
>> the value for a 'case:' really has to look like a constant, not just
>> happen to evaluate to one.
>
> Yes, this requirement was explicitly built-in.  See how the various
> __swabXX bits are done in linux/swab.h.

Cool, thanks!

NeilBrown

