Return-Path: <linux-kernel-owner+w=401wt.eu-S968995AbXEHWxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968995AbXEHWxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968599AbXEHWxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:53:25 -0400
Received: from v05705.home.net.pl ([212.85.118.117]:63066 "HELO
	v05705.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S968590AbXEHWxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:53:24 -0400
Date: Wed, 9 May 2007 00:53:33 +0200
From: Zbigniew Baniewski <zb@ispid.com.pl>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "modularized" 2.4.34.4  ->  ide-core "unresolved symbols"
Message-ID: <20070508225333.GA19063@localhost.localdomain>
References: <20070505194922.GA13176@localhost.localdomain> <20070506043645.GF943@1wt.eu> <20070508202334.GA16185@localhost.localdomain> <20070508211646.GA3129@1wt.eu> <20070508221425.GA18244@localhost.localdomain> <20070508223922.GB31591@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
In-Reply-To: <20070508223922.GB31591@1wt.eu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:39:22AM +0200, Willy Tarreau wrote:

> This "sanscrit-like" language is an oops (in fact a kernel panic, but the
> dump format is called an oops). It is what developers use to find bugs.

Of course, I'm aware. ;)

> I see that you're using devfs.

No, I'm not. No idea, why it has been enabled... :-O  just added grsecurity
patch to the previous .config, switched ata-module to be compiled directly
into kernel - and made new compilation.

> If you're pretty certain that you need DEVFS, then for a test, please
> set a max of IDE options to YES instead of MODULE. At least all the ones
> you need to boot on this system.

OK, I'll repeat the compilation making sure, that devfs is disabled.
-- 
				pozdrawiam / regards

						Zbigniew Baniewski
