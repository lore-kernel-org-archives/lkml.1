Return-Path: <linux-kernel-owner+w=401wt.eu-S1751257AbZLMFUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbZLMFUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 00:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbZLMFUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 00:20:36 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:19257 "HELO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750780AbZLMFUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 00:20:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=VfrCGigQGN3w/GgvdbQvQidIs3baeMDVqXfr4h9FKh+Oj144+rN+CuNbn9Qea3wmZE
         H9XfKBjQmGWSuaUwxdyQo0wWHksOBdKk71WUjhrtSyUvzhYageYaNmStqDuLClfEbQvc
         cO3NfYrs6MW3YiWGPDd9vawZC+YMX4mg+lEZw=
MIME-Version: 1.0
In-Reply-To: <20091213050900.GC4369@heat>
References: <20091213034418.GA4416@heat> <20091213050900.GC4369@heat>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sat, 12 Dec 2009 21:20:13 -0800
Message-ID: <a36005b50912122120n4656b97bx6a6d862a57671e6d@mail.gmail.com>
Subject: Re: setrlimit(RLIMIT_NETWORK) vs. prctl(???)
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>,
       =?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= <rdenis@simphalempin.com>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 21:09, Michael Stone <michael@laptop.org> wrote:
>> That being said, I'm not wedded to the decision. Could you give me some
>> more
>> specific examples of the kinds of changes in low-level userspace code that
>> you're worried about?

It was an accident that I sent the email privately.

As summarized in the paraphrased comment, it's a pain to deal with
rlimit extensions.  It's easy enough to do all this using prctl() with
the same semantics and without forcing any other code to be modified.
I let others more competent to judge the usefulness.  But using rlimit
as the interface is just plain wrong.
