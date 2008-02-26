Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbYBZXNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbYBZXNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932324AbYBZXNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:13:34 -0500
Received: from khc.piap.pl ([195.187.100.11]:54139 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbYBZXNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:13:33 -0500
To: davids@webmaster.com
Cc: <Valdis.Kletnieks@vt.edu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@redhat.com>
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
References: <MDEHLPKNGKAHNMBLJOLKKEONKKAC.davids@webmaster.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 27 Feb 2008 00:13:31 +0100
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEONKKAC.davids@webmaster.com> (David Schwartz's message of "Tue\, 26 Feb 2008 10\:19\:42 -0800")
Message-ID: <m3ir0bcnvo.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David Schwartz" <davids@webmaster.com> writes:

> The agreement made when the feature was added was that EXPORT_GPL was not a
> license enforcement mechanism but was an indication that someone believed
> that any use of the symbol was possible only a derivative work that would
> need to be distributed under the GPL.

But the above gives us nothing.
*If* any use of non-GPL symbols only by a binary module was ok then it
would make sense.

>> Actually I think the _GPL exports are really harmful - somebody
>> distributing a binary module may claim he/she doesn't violate the GPL
>> because the module uses only non-GPL exports.
>
> Anyone can argue anything. That would be an obviously stupid argument.
> Perhaps clearer documentation might be helpful, but the GPL speaks for
> itself.

Not sure if the court would share this opinion.
Defendant: my module doesn't use any GPL-only export!
Plaintiff: but using XXX normal symbol is a violation too!
D: so why have you created that _GPL thing exactly?

Additionally:
D: top of the COPYING file explicity states binary modules are ok.


This is of course fine if we consider normal use of non-GPL-only
symbols ok.

> They serve as a warning and, as a practical matter, may make it a bit more
> difficult to violate the license.

Technically only.


I have to agree with Alan that the list of non-GPL modules only is
quite tiny nowadays. Madwifi is in terminal state, ATI is opening the
docs and working on GPL driver, modem drivers are mostly thing of
the past, NVidias will probably be supported by the open source driver
soon even if they don't open their code.

Embedded devices have full Linux, not just modules.
-- 
Krzysztof Halasa
