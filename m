Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbXLDQSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbXLDQSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbXLDQSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:18:17 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41693 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752925AbXLDQSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:18:17 -0500
Date: Tue, 4 Dec 2007 17:18:11 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204161811.GB15974@stusta.de>
References: <20071204114125.GA17310@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071204114125.GA17310@torres.zugschlus.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 12:41:25PM +0100, Marc Haber wrote:

> While debugging Exim4's GnuTLS interface, I recently found out that
> reading from /dev/urandom depletes entropy as much as reading from
> /dev/random would. This has somehow surprised me since I have always
> believed that /dev/urandom has lower quality entropy than /dev/random,
> but lots of it.

man 4 random

> This also means that I can "sabotage" applications reading from
> /dev/random just by continuously reading from /dev/urandom, even not
> meaning to do any harm.
> 
> Before I file a bug on bugzilla,
>...

The bug would be closed as invalid.

No matter what you consider as being better, changing a 12 years old and 
widely used userspace interface like /dev/urandom is simply not an 
option.

> Greetings
> Marc

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

