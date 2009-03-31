Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbZCaVZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbZCaVZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZCaVZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:25:30 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1879 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZCaVZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:25:30 -0400
Subject: Re: [PATCH 0/8] MAINTAINERS - add script and patterns
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, pavel@ucw.cz
In-Reply-To: <20090330135315.a05854da.akpm@linux-foundation.org>
References: <1237331969-28565-1-git-send-email-joe@perches.com>
	 <20090330135315.a05854da.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 14:24:08 -0700
Message-Id: <1238534648.9715.306.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 13:53 -0700, Andrew Morton wrote:
> Will that be OK?  Will the tool still work OK is MAITNAINERS is a bit
> wrong?

More or less.  By default it will still use git
"-by:" signers.  More pattern coverage is better.

> Is the tool capable of detecting misformatted MAINTAINERS entries?  If
> so, that would help long-term maintenance a lot.

Not really.

The MAINTAINERS file format is weakly specified.

I have a separate script that looks for patterns
that have no file matches and sections that have
no patterns.

Any suggestions?

btw: I did not do any patterns for ARM or PowerPC.
Of course those could be added in the future.

> I never have seen [patch 2/8] because the linux-foundation mail server
> thinks it's spam.

Actually, if the mail server is to be believed, the
MAINTAINERS file already contains a SPAM URI and
could be rejected if you sent it to yourself as-is.

On Tue, 2009-03-17 at 15:22 -0800, Mail Delivery Subsystem wrote:
>    ----- The following addresses...
> <torvalds@linux-foundation.org>
> <akpm@linux-foundation.org>
> 
>    ----- Transcript of session follows -----
> ... while talking to smtp1.linux-foundation.org.:
> >>> DATA
> <<< 451 4.3.2 Please try again later
> ... while talking to smtp2.linux-foundation.org.:
> >>> DATA
> <<< 554 5.7.1 Email body contains Spam URI
> 554 <akpm@linux-foundation.org>,<torvalds@linux-foundation.org>... Service unavailable

> So if all the above looks OK then please resend
> everything (yet again) to akpm@kernel.org.

Do you want me to wait for RC1 when most of the
MAINTAINERS changes should be done or do you want
it now?


