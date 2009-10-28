Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZJ1QAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZJ1QAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZJ1QAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:00:13 -0400
Received: from mail.perches.com ([173.55.12.10]:1111 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbZJ1QAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:00:13 -0400
Subject: Re: [PATCH] scripts/get_maintainer.pl: display frequently used tags
From: Joe Perches <joe@perches.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AE84F57.9030902@gmail.com>
References: <4AE84F57.9030902@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 09:00:16 -0700
Message-ID: <1256745617.29938.114.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 15:04 +0100, Roel Kluin wrote:
> With the flag --tags, show frequently used tags.
> 
> $ ./scripts/get_maintainer.pl --tags -f ./sound/core/
> 71 times observed tag ALSA:
> What do you think of this?

Hi Roel.

I don't see a benefit to finding maintainers for
a particular patch or file/directory here.

I think git should be used for what git does well.

$ git log --since=1-year-ago --format=%s sound/core | grep "ALSA" | wc -l
72

Maybe if something like git log -grep were used to
find patterns and the signers for that pattern.

That's a bit like the recently added "K:" keyword.

cheers, Joe

