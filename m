Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZLXS5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZLXS5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 13:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZLXS5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 13:57:54 -0500
Received: from bob75-7-88-160-5-175.fbx.proxad.net ([88.160.5.175]:48566 "EHLO
	cerbere.dyndns.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbZLXS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 13:57:54 -0500
From: Samir Bellabes <sam@synack.fr>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
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
       =?iso-8859-15?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: A basic question about the security_* hooks
References: <20091224022902.GA24234@heat> <20091224073654.GD16133@ioremap.net>
Date: Thu, 24 Dec 2009 19:57:52 +0100
In-Reply-To: <20091224073654.GD16133@ioremap.net> (Evgeniy Polyakov's message
	of "Thu, 24 Dec 2009 10:36:54 +0300")
Message-ID: <m2637w42tr.fsf@ssh.synack.fr>
User-Agent: Gnus/5.110003 (No Gnus v0.3) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov <zbr@ioremap.net> writes:

> I believe you should convice selinux and friends to add support for your
> extension, otherwise no distribution will be able to turn it on, since
> no two security frameworks can be registered simultaneously.

I agree, as a LSM module, this purpose is a no sense, because it will
avoid using another security module.
On the other hand, adding this capacity directly to the syscalls seems
to be a little bit ugly (it reminds me security post_accept hook
strategy of returning or not a value). 

But the way to go is to add this directly to existing security models,
if it make sens for them.

sam
