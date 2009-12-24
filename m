Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZLXFl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZLXFl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 00:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZLXFl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 00:41:57 -0500
Received: from lists.laptop.org ([18.85.2.145]:40104 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751282AbZLXFl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 00:41:56 -0500
Date: Thu, 24 Dec 2009 00:44:00 -0500
From: Michael Stone <michael@laptop.org>
To: Samir Bellabes <sam@synack.fr>
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
	interface. (v3)
Message-ID: <20091224054359.GA24396@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <m2pr653s1l.fsf@ssh.synack.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think this is unnecessary, as LSM module, you should use the
> void* security member of the structure cred. 

The change you propose is easily made but I'm having trouble seeing how making
it would help my purpose: the field you name is already in use by other parts
of the kernel which my functionality is intended to complement.

That being said, I'd be very happy to prepare a version of the patch using the
strategy you suggest if it would be directly useful to you or if you can show
me how it would contribute to my goals.

Regards, and thanks for your comment,

Michael

P.S. - Perhaps a reasonable alternative would be to the definition of the field
conditional on CONFIGURE_SECURITY_PRCTL_NETWORK?
