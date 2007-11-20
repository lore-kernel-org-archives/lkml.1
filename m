Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbXKTSmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbXKTSmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbXKTSml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:42:41 -0500
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:52346 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708AbXKTSmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:42:40 -0500
Date: Tue, 20 Nov 2007 20:42:35 +0200
From: Sami Farin <safari-kernel@safari.iki.fi>
To: linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
Message-ID: <20071120184235.3bcfy3y2f4lc3s7i@m.safari.iki.fi>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <E1IuMnZ-0003o3-00@gondolin.me.apana.org.au> <4742831F.9040408@zytor.com> <20071120065212.GA14702@gondor.apana.org.au> <5a4c581d0711200452u1f7c9dc3h63e2697926ce1be0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a4c581d0711200452u1f7c9dc3h63e2697926ce1be0@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-15)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 13:52:52 +0100, Alessandro Suardi wrote:
> On Nov 20, 2007 7:52 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Mon, Nov 19, 2007 at 10:47:59PM -0800, H. Peter Anvin wrote:
> > >
> > > This one is definitely messy.  There is absolutely no way to know what
> > > gcc has miscompiled.  It looks to me that both gcc 4.2 and 4.3 are
> > > affected, any others?
> >
> > I just tested it here and gcc 3.3 is also affected so presumably
> > everything in between is too.  Gcc 2.95 is not affected.  I don't
> > have the intervening versions to test.
> 
> Fedora 7's 4.1.2-27 is also affected.

-m32:
2.7.2.3: /tmp/cc1EO0wg.s:14: Error: suffix or operands invalid for `push'
2.95.3: OK
3.0.4: broken
3.1.1: broken
3.2.3: broken
3.3.5: broken
3.4.6: broken
4.0.3: broken

-m32 and -m64:
gcc Red Hat 4.1.2-33: broken
4.2.2 20070909 (prerelease): broken

-- 
Do what you love because life is too short for anything else.

