Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbXB1U5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbXB1U5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXB1U5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:57:17 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:40710 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbXB1U5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:57:16 -0500
Subject: Re: [PATCH 5/5] jffs2: Allow selection of compression mode via a
	sysfs attribute
From: Richard Purdie <rpurdie@openedhand.com>
To: dedekind@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       herbert@gondor.apana.org.au, linux-mtd <linux-mtd@lists.infradead.org>,
       linux-crypto@vger.kernel.org
In-Reply-To: <1172691583.17031.35.camel@sauron>
References: <1172690034.16062.144.camel@localhost.localdomain>
	 <1172691583.17031.35.camel@sauron>
Content-Type: text/plain
Date: Wed, 28 Feb 2007 20:56:56 +0000
Message-Id: <1172696216.16062.147.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-28 at 21:39 +0200, Artem Bityutskiy wrote:
> On Wed, 2007-02-28 at 19:13 +0000, Richard Purdie wrote:
> > +/* gives us jffs2_subsys */
> > +static decl_subsys(jffs2, NULL, NULL);
> 
> There is actually a file-system subsys - look up for fs_subsys. It is
> declared at fs/namespace.c.

Further down the patch you'll see:

+	kset_set_kset_s(&jffs2_subsys, fs_subsys);

There was a reason for doing that instead using fs_subsys in the above
although I can't remember why offhand. I did try it and it didn't work
as expected...

Regards,

Richard

