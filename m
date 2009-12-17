Return-Path: <linux-kernel-owner+w=401wt.eu-S1764403AbZLQRwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764403AbZLQRwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760455AbZLQRwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:52:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60996 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZLQRwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:52:35 -0500
Date: Thu, 17 Dec 2009 18:52:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>,
       =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <rdenis@simphalempin.com>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: Network isolation with RLIMIT_NETWORK, cont'd.
Message-ID: <20091217175230.GK9804@basil.fritz.box>
References: <20091213034418.GA4416@heat> <m1ljh7jijk.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ljh7jijk.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Solve that with an unused uid.  That ptrace_may_access check is
> completely non-intuitive, and a problem if we ever remove the current
> == task security module bug avoidance.

I thought he wanted to do that without suid?

If he can change uids he can as well just use full network namespaces.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
