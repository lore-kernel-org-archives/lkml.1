Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYGDMeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYGDMeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYGDMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:34:16 -0400
Received: from khc.piap.pl ([195.187.100.11]:45594 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYGDMeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:34:16 -0400
To: Oliver Neukum <oliver@neukum.org>
Cc: =?iso-8859-2?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: [RFC] MAINTAINERS service, was: Re: alphabetic ordering of MAINTAINERS
References: <20080704063455.GA13999@digi.com>
	<200807040852.27809.oliver@neukum.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 04 Jul 2008 14:34:13 +0200
In-Reply-To: <200807040852.27809.oliver@neukum.org> (Oliver Neukum's message of "Fri\, 4 Jul 2008 08\:52\:27 +0200")
Message-ID: <m3k5g1zv3u.fsf_-_@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum <oliver@neukum.org> writes:

>> I wanted to add an entry to MAINTAINERS and while doing it I saw that in
>> the corresponding region the alphabetic ordering is broken.  Then I
>> inteded to fix that up for a trivial patch.  Next was to check the rest
>> of the file and there are so much misorderings that it's not sensible to
>> choose the trivial path anymore as there are currently 114 entries out
>> of order[1].
>
> What good does alphabetic ordering? You'll grep it anyway.

I was thinking about a mailing list / database service instead:
- source file/directory-based (e.g. someone could maintain whole
  drivers/, someone else drivers/char and others drivers/char/asdfg.[ch])
- people would be able to add themselves as "observers" using mail
  and/or HTML interface
- sending a patch would automatically trigger Cc: to all people
  registered as maintainers (or "observers") for the files modified
- full recipient list would be present in mail sent by the service, so
  the following discussion wouldn't need it anymore. It would be used
  only for posting patches.
- as such, I don't expect a need for spam filtering - messages
  containing no patch would be rejected in the SMTP session.

Pro: no more missing Cc:, no more manual lookups and guessing, you
     just Cc: the service, possibility for "observers".
Con: another thing to create and maintain, you don't immediately know
     who exactly has been sent a copy.

I think I could create a test service but after the test phase it
should probably go to some machine more reliable/able than mine.

Comments?
-- 
Krzysztof Halasa
