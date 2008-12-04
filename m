Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYLDBeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYLDBeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbYLDBd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:33:59 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:37140 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbYLDBd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:33:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=e55gDXxrXYvXCeNes1QgospJ78AgNuTlI6/PC1qySbAWy047dwgaPPMWNcehv9ZB0o
         qNfVzjjfJRhRv+M8q8Zm+RjaGKi3myv76ylT6Z2JCaJevxaaMXqRQmWq7jh0OqOcVhcs
         ZT3OZnAOiB2Tl/iwzxFsq7Y0jgsouA6oursLI=
Message-ID: <8bd0f97a0812031733n18184927m2b4fcfa0ed05cd7b@mail.gmail.com>
Date: Wed, 3 Dec 2008 20:33:57 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: Yet more ARM breakage in linux-next
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, "Stephen Rothwell" <sfr@canb.auug.org.au>
In-Reply-To: <200812040952.44957.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081203192905.GA12502@flint.arm.linux.org.uk>
	 <20081203124109.79f8f15b.akpm@linux-foundation.org>
	 <200812040952.44957.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 18:22, Rusty Russell wrote:
> On Thursday 04 December 2008 07:11:09 Andrew Morton wrote:
>> On Wed, 3 Dec 2008 19:29:05 +0000
>>
>> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
>> > This seems to be causing lots of ARM breakage:
>> >
>> > lib/find_next_bit.c:183: error: implicit declaration of function '__fls'
>> >
>> > Whoever's responsible,
>>
>> git-blame?
>
> It's me.  Turns out sparc, avr32 and arm all don't define __fls in their
> asm/bitops.h, and I'm the first one to use it in generic code.

the Blackfin port also does not ... you going to post a change for
that since the build breaks for Blackfin atm too ?
-mike
