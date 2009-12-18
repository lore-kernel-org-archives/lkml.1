Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbZLRRUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbZLRRUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZLRRUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:20:36 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37861 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751873AbZLRRUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:20:35 -0500
Date: Fri, 18 Dec 2009 17:20:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Stone <michael@laptop.org>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?ISO-8859-14?B?QW3pcmljbw==?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/3] Security: Add prctl(PR_{GET,SET}_NETWORK)
Message-ID: <20091218172054.556de51b@lxorguk.ukuu.org.uk>
In-Reply-To: <20091218163348.GA24269@heat>
References: <20091218154634.79decdc4@lxorguk.ukuu.org.uk>
	<20091218163348.GA24269@heat>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the LSM-based version *does not* resolve the situation to my satisfaction as a
> userland hacker due to the well-known and long-standing adoption and
> compositionality problems facing small LSMs. ;)

For things like Fedora it's probably an "interesting idea, perhaps we
should do it using SELinux" sort of problem, but a config option for a
magic network prctl is also going to be hard to adopt without producing a
good use case - and avoiding that by dumping crap into everyones kernel
fast paths isn't a good idea either.

