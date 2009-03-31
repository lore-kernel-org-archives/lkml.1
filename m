Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbZCaVrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbZCaVrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761646AbZCaVrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:47:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757419AbZCaVrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:47:32 -0400
Date: Tue, 31 Mar 2009 14:45:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 0/8] MAINTAINERS - add script and patterns
Message-Id: <20090331144506.3737e832.akpm@linux-foundation.org>
In-Reply-To: <1238534648.9715.306.camel@localhost>
References: <1237331969-28565-1-git-send-email-joe@perches.com>
	<20090330135315.a05854da.akpm@linux-foundation.org>
	<1238534648.9715.306.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 14:24:08 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2009-03-30 at 13:53 -0700, Andrew Morton wrote:
> > Will that be OK?  Will the tool still work OK is MAITNAINERS is a bit
> > wrong?
> 
> More or less.  By default it will still use git
> "-by:" signers.  More pattern coverage is better.
> 
> > Is the tool capable of detecting misformatted MAINTAINERS entries?  If
> > so, that would help long-term maintenance a lot.
> 
> Not really.
> 
> The MAINTAINERS file format is weakly specified.
> 
> I have a separate script that looks for patterns
> that have no file matches and sections that have
> no patterns.
> 
> Any suggestions?

Don't worry about it for now.  Have a think about it later, as
MAINTAINERS maintainer ;)

> btw: I did not do any patterns for ARM or PowerPC.
> Of course those could be added in the future.
> 
> > I never have seen [patch 2/8] because the linux-foundation mail server
> > thinks it's spam.
> 
> Actually, if the mail server is to be believed, the
> MAINTAINERS file already contains a SPAM URI and
> could be rejected if you sent it to yourself as-is.
> 
> On Tue, 2009-03-17 at 15:22 -0800, Mail Delivery Subsystem wrote:
> >    ----- The following addresses...
> > <torvalds@linux-foundation.org>
> > <akpm@linux-foundation.org>
> > 
> >    ----- Transcript of session follows -----
> > ... while talking to smtp1.linux-foundation.org.:
> > >>> DATA
> > <<< 451 4.3.2 Please try again later
> > ... while talking to smtp2.linux-foundation.org.:
> > >>> DATA
> > <<< 554 5.7.1 Email body contains Spam URI
> > 554 <akpm@linux-foundation.org>,<torvalds@linux-foundation.org>... Service unavailable
> 
> > So if all the above looks OK then please resend
> > everything (yet again) to akpm@kernel.org.
> 
> Do you want me to wait for RC1 when most of the
> MAINTAINERS changes should be done or do you want
> it now?

At -rc1 please.  Let's try it out and if it looks good I'll see if I
can fool Linus into taking it for -rc2, when things are a bit quieter.


