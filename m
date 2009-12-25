Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbZLYRJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbZLYRJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 12:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZLYRJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 12:09:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42756 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbZLYRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 12:09:17 -0500
Date: Fri, 25 Dec 2009 18:09:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michael Stone <michael@laptop.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
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
       Am?rico Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/3] Security: Add prctl(PR_{GET,SET}_NETWORK)
Message-ID: <20091225170908.GA1581@ucw.cz>
References: <20091218154634.79decdc4@lxorguk.ukuu.org.uk> <20091218163348.GA24269@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218163348.GA24269@heat>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-18 11:33:48, Michael Stone wrote:
> Alan Cox wrote:
>
>> This is a security model, it belongs as a security model using LSM. 
>
> I'll see what I can cook up for you.
>
> However, please don't be surprised when the resulting cover letter states that
> the LSM-based version *does not* resolve the situation to my satisfaction as a
> userland hacker due to the well-known and long-standing adoption and
> compositionality problems facing small LSMs. ;)

Maybe it is time to fix the LSM? This excuse is much too common...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
