Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYE1VcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYE1VcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYE1VcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:32:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:19692 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYE1VcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=W/3zIb+xtiiKZ8PNHesNACXWU1IMtBivTOYM2hQJaWZomBxK654ELTHveDv9hnoa9CMjFFTmiup/uSLNNyLIYm6sVie06P1QBLVfsQEn8jLMdWSX9dOCU/aO3AwivP9qUTKgWNZ4VhHTsTv9n9v7ONZzhRpjM9LET5LRTGctbtU=
Message-ID: <84144f020805281431y1aac903am442b333a2a13cd15@mail.gmail.com>
Date: Thu, 29 May 2008 00:31:59 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Cc: "David Woodhouse" <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1212008517.3445.89.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211995212.3445.52.camel@localhost.localdomain>
	 <1212007760.2236.17.camel@shinybook.infradead.org>
	 <1212008517.3445.89.camel@localhost.localdomain>
X-Google-Sender-Auth: 38d34e720228a394
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Thu, May 29, 2008 at 12:01 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Right, but that's why I think we have to change the process.  If we keep
> the Janitors project, then the bar has to be raised so that it becomes
> more participatory and thought oriented (i.e. eliminate from the outset
> anyone who is not going to graduate from mechanical changes to more
> useful ones).

I'm not sure what you expect to happen if we "shut down" the Janitors
project. The important janitorial work doesn't just magically
disappear. For example, we still need people for:

  - Fixing API misuse
  - Converting code from old APIs to new ones
  - Consolidating duplicate code
  - Fixing error handling code
  - Removing unused code
  - De-obfuscating code (e.g. removing bad macro magic, etc.)

And, quite frankly, I don't see what the big fuss is about. I know
we've had way too many "whitespace cleanup" patches in the past six
months or so, but can't we just NAK them politely and be done with it?

                        Pekka
