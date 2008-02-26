Return-Path: <linux-kernel-owner+w=401wt.eu-S1763135AbYBZPoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763135AbYBZPoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759370AbYBZPoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:44:00 -0500
Received: from khc.piap.pl ([195.187.100.11]:57838 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758993AbYBZPn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:43:59 -0500
To: davids@webmaster.com
Cc: <Valdis.Kletnieks@vt.edu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@redhat.com>
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
References: <MDEHLPKNGKAHNMBLJOLKGEKDKKAC.davids@webmaster.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 26 Feb 2008 16:43:57 +0100
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEKDKKAC.davids@webmaster.com> (David Schwartz's message of "Mon\, 25 Feb 2008 17\:30\:40 -0800")
Message-ID: <m3d4qj90zm.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David Schwartz" <davids@webmaster.com> writes:

> I don't know who told you that or why, but it's obvious nonsense,

Correct.

> Exports should be marked GPL if and only if they cannot be used
> except in a derivative work. If it is possible to use them without taking
> sufficient protectable expression, they should not be marked GPL.

This isn't very obvious to me.

The licence doesn't talk about GPL or non-GPL exports. It doesn't
restrict the use, only distribution of the software. One is free to
remove _GPL from the code and distribute it anyway (except perhaps for
some DMCA nonsense).

If a code is a derivative work it has to be distributed (use is not
restricted) under GPL, EXPORT _GPL or not _GPL.

One may say _GPL is a strong indication that all users are
automatically a derivative works, but it's only that - indication. It
doesn't mean they are really derivative works and it doesn't mean a
module not using any _GPL exports isn't a derivative.

I think introducing these _GPL symbols was a mistake in the first place.
-- 
Krzysztof Halasa
