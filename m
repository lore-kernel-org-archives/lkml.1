Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbXKFOaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbXKFOaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXKFOai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:30:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:57847 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbXKFOag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:30:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DdejGkK4Se2FbEn+AQoTT/2/aKDUbtwuJidXmf70Z/dzAzJ1cyqexaK1+EnemW1WxIxkjQheECHbcDhTwHXMt9RXwchyy4J5naj7YhOpqn6Q4hzVjeVBK/uwIXV/1flUK220zKL25f13rJQDUtYKxiSji1u7fUMn1h23Vu+/p1I=
Message-ID: <1865922a0711060630i4d67f8a5ka2fd30494a525ac9@mail.gmail.com>
Date: Tue, 6 Nov 2007 16:30:35 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Cc: "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Casey Schaufler" <casey@schaufler-ca.com>, akpm@osdl.org,
       torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071106141037.GL26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071103164303.GA26707@ubuntu>
	 <C1C917F8-57EA-434C-9FD8-CB5A4EAF2653@mac.com>
	 <20071106085651.GC26163@stusta.de> <20071106113359.GA6041@ubuntu>
	 <20071106114738.GH26163@stusta.de>
	 <1865922a0711060423ue81dbdct413b993e727f6f9@mail.gmail.com>
	 <46B300CD-7A35-4E81-A0AE-EC2BB72016DD@mac.com>
	 <20071106133446.GI26163@stusta.de> <20071106140504.GA6310@ubuntu>
	 <20071106141037.GL26163@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/07, Adrian Bunk <bunk@kernel.org> wrote:
> On Tue, Nov 06, 2007 at 04:05:13PM +0200, Ahmed S. Darwish wrote:
> >
> > Great, To summarize the discussion. Will there be a problem in
> > accepting ASCII and the UTF-8 ASCII _subset_ _only_ and  return
> > -EINVAL for all other cases/ecnodings ?.
>
> The UTF-8 ASCII subset is the complete ASCII.
>
> > i.e. The fragment I sent in a previous message:
> >
> > /* Filter UTF-8 non-ascii compatible bytes (> 0x7F) */
> > if (!isascii(c)) return -EINVAL;
> > /* Filter unwanted ascii chars */
> > if (!isspace(c) && !isgraph(c)) return -EINVAL;
> >...
>
> As I already said, this should work fine.
>

I thought you were objecting not handling the remaining non-ASCII
UTF-8 bytes. Everything is clear now. A Big thank you to everybody in
this thread for your effort on this :).

Regards,

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
