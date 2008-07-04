Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbYGDOIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbYGDOIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYGDOId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:08:33 -0400
Received: from khc.piap.pl ([195.187.100.11]:40573 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbYGDOIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:08:32 -0400
To: Uwe =?iso-8859-2?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] MAINTAINERS service, was: Re: alphabetic ordering of MAINTAINERS
References: <20080704063455.GA13999@digi.com>
	<200807040852.27809.oliver@neukum.org>
	<m3k5g1zv3u.fsf_-_@maximus.localdomain>
	<20080704134426.GA32700@digi.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 04 Jul 2008 16:08:30 +0200
In-Reply-To: <20080704134426.GA32700@digi.com> ("Uwe =?iso-8859-2?Q?Kleine?=
 =?iso-8859-2?Q?-K=F6nig=22's?= message of "Fri\, 4 Jul 2008 15\:44\:26
 +0200")
Message-ID: <m37ic1zqqp.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com> writes:

> Why not make that a script that parses MAINTAINERS and lives in scripts/
> and that can be used as --cc-cmd to git-send-email?  Then no service
> needs to be maintained, you don't get the observers functionality
> though.  (But that's what mailing lists are good for.)
>
> Of course MAINTAINERS needs to be modified to have the path specifiers.

Because then:
- the action is not effective immediately but sometimes after few
  months, not counting people still working with 2.6.12 or so.
- IMHO adding Cc: patch-service is a bit easier than using a script
- I think the "observers" thing is worth the effort. Now I only see
  changes to certain areas I'm interested in when they are accepted
  upstream.
- maintaining the script is probably more work than maintaining the
  database :-)

And with a service you can:
- maintain a patch archive
- be sure nobody tries to be "creative"
- perhaps other things I haven't thought about.
-- 
Krzysztof Halasa
