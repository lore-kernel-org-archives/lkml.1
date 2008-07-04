Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbYGDNom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbYGDNom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYGDNod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:44:33 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:43121 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbYGDNoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:44:32 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-2.tower-164.messagelabs.com!1215179071!8576617!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Fri, 4 Jul 2008 15:44:26 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Oliver Neukum <oliver@neukum.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] MAINTAINERS service, was: Re: alphabetic ordering of MAINTAINERS
Message-ID: <20080704134426.GA32700@digi.com>
References: <20080704063455.GA13999@digi.com> <200807040852.27809.oliver@neukum.org> <m3k5g1zv3u.fsf_-_@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3k5g1zv3u.fsf_-_@maximus.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 04 Jul 2008 13:44:27.0153 (UTC) FILETIME=[139B0810:01C8DDDC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Krzysztof Halasa wrote:
> Oliver Neukum <oliver@neukum.org> writes:
> 
> >> I wanted to add an entry to MAINTAINERS and while doing it I saw that in
> >> the corresponding region the alphabetic ordering is broken.  Then I
> >> inteded to fix that up for a trivial patch.  Next was to check the rest
> >> of the file and there are so much misorderings that it's not sensible to
> >> choose the trivial path anymore as there are currently 114 entries out
> >> of order[1].
> >
> > What good does alphabetic ordering? You'll grep it anyway.
> 
> I was thinking about a mailing list / database service instead:
> - source file/directory-based (e.g. someone could maintain whole
>   drivers/, someone else drivers/char and others drivers/char/asdfg.[ch])
> - people would be able to add themselves as "observers" using mail
>   and/or HTML interface
> - sending a patch would automatically trigger Cc: to all people
>   registered as maintainers (or "observers") for the files modified
> - full recipient list would be present in mail sent by the service, so
>   the following discussion wouldn't need it anymore. It would be used
>   only for posting patches.
> - as such, I don't expect a need for spam filtering - messages
>   containing no patch would be rejected in the SMTP session.
> 
> Pro: no more missing Cc:, no more manual lookups and guessing, you
>      just Cc: the service, possibility for "observers".
> Con: another thing to create and maintain, you don't immediately know
>      who exactly has been sent a copy.
Why not make that a script that parses MAINTAINERS and lives in scripts/
and that can be used as --cc-cmd to git-send-email?  Then no service
needs to be maintained, you don't get the observers functionality
though.  (But that's what mailing lists are good for.)

Of course MAINTAINERS needs to be modified to have the path specifiers.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
