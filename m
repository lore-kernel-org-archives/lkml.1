Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZLXHhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZLXHhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 02:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZLXHhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 02:37:00 -0500
Received: from netgear.net.ru ([195.178.208.66]:57002 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbZLXHg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 02:36:59 -0500
Date: Thu, 24 Dec 2009 10:36:54 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: A basic question about the security_* hooks
Message-ID: <20091224073654.GD16133@ioremap.net>
References: <20091224022902.GA24234@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091224022902.GA24234@heat>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 09:29:02PM -0500, Michael Stone (michael@laptop.org) wrote:
> There are a variety of places where I'd like to be able to get the kernel to
> return EPERM more often [1]. Many of these places already have security 
> hooks.
> 
> Unfortunately, I don't feel that I can make effective use of these hooks
> because they seem to be "occupied" by the large mandatory access control
> frameworks.

I believe you should convice selinux and friends to add support for your
extension, otherwise no distribution will be able to turn it on, since
no two security frameworks can be registered simultaneously.

-- 
	Evgeniy Polyakov
