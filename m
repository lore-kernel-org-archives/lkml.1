Return-Path: <linux-kernel-owner+w=401wt.eu-S936431AbZLQSZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936431AbZLQSZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935588AbZLQSZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:25:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:5530 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935516AbZLQSZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:25:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=T26ywqb8whtrFitny23sU+ee4m1Yv8qlvq1cKQ7fl30EyfAM0XsdRV61hmkDZXsvY+
         thwboywbu38MtHut5OO5NEovAKnlsFJC+CqrktvYGNw4/FKejZjzM6nTBys+muT3ZWeY
         i01Pnz/AbVMFYfj3JwXrPAX3gnmw2xil/iIp8=
MIME-Version: 1.0
In-Reply-To: <fb69ef3c0912170931l5cbf0e3dh81c88e6502651042@mail.gmail.com>
References: <m1ljh7jijk.fsf@fess.ebiederm.org> <20091213142149.GB4777@heat> 
	<fb69ef3c0912170931l5cbf0e3dh81c88e6502651042@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 17 Dec 2009 13:24:50 -0500
Message-ID: <3e8340490912171024n2120e88q569c69fe7d09140f@mail.gmail.com>
Subject: Re: Network isolation with RLIMIT_NETWORK, cont'd.
To: Mark Seaborn <mrs@mythic-beasts.com>
Cc: Michael Stone <michael@laptop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <rdenis@simphalempin.com>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Linux Containers <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 12:31 PM, Mark Seaborn <mrs@mythic-beasts.com> wrote:

> Maybe we could fix (b) by making mount namespaces into first class objects
> that can be named through a file descriptor, so that one process can
> manipulate another process's namespace without itself being subject to the
> namespace.

Can this be done using openat() and friends currently? It would seem
the natural way to implement this; open /proc/(pid)/root, then
openat() things from there (or even chdir to it and see the mounts
that it sees from there...)
