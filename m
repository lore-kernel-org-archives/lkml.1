Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZLRQby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZLRQby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZLRQbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:31:52 -0500
Received: from lists.laptop.org ([18.85.2.145]:33336 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750888AbZLRQbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:31:51 -0500
Date: Fri, 18 Dec 2009 11:33:48 -0500
From: Michael Stone <michael@laptop.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/3] Security: Add prctl(PR_{GET,SET}_NETWORK)
Message-ID: <20091218163348.GA24269@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091218154634.79decdc4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> This is a security model, it belongs as a security model using LSM. 

I'll see what I can cook up for you.

However, please don't be surprised when the resulting cover letter states that
the LSM-based version *does not* resolve the situation to my satisfaction as a
userland hacker due to the well-known and long-standing adoption and
compositionality problems facing small LSMs. ;)

Regards,

Michael

P.S. - Dan is cited in my patch because I wish to honor him for anticipating my
desires early, clearly, and in writing. However, if you know of an earlier
citation, then I'll be happy to include that one too.
