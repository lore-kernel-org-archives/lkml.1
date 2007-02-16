Return-Path: <linux-kernel-owner+w=401wt.eu-S966254AbXBPJ02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966254AbXBPJ02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966258AbXBPJ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:26:28 -0500
Received: from ns.firmix.at ([62.141.48.66]:42485 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966254AbXBPJ01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:26:27 -0500
Subject: Re: GPL vs non-GPL device drivers
From: Bernd Petrovitsch <bernd@firmix.at>
To: Valdis.Kletnieks@vt.edu
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Manu Abraham <abraham.manu@gmail.com>, Mws <mws@twisted-brains.org>,
       v j <vj.linux@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200702160819.l1G8JnmZ013706@turing-police.cc.vt.edu>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <200702151254.39058.mws@twisted-brains.org>
	 <1a297b360702150451n3dca1140ra6827cfde020eed5@mail.gmail.com>
	 <Pine.LNX.4.61.0702150913020.1735@chaos.analogic.com>
	 <200702160819.l1G8JnmZ013706@turing-police.cc.vt.edu>
Content-Type: text/plain
Organization: Firmix software GmbH
Date: Fri, 16 Feb 2007 10:25:57 +0100
Message-Id: <1171617957.23981.5.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.416 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.416 required=5
X-Spam-Score: -2.416 () AWL,BAYES_00,FORGED_RCVD_HELO
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 03:19 -0500, Valdis.Kletnieks@vt.edu wrote:
[...]
> Actually, the *real* reason embedded systems end up using old versions is
> much simpler.

ACK.

> They start developing their code on release 2.X.Y, and they keep their code
> out-of-tree.  Then, when they come up for air, and it's at 2.X.(Y+15), they
> discover that we weren't kidding when we shipped stable_api_nonsense.txt,
> and since their code isn't in the tree, they have to do all the API cleanup
> themselves, because no flock of nit-picking kernel janitor monkeys swarmed
> over their code and magically fixed it up for them.

Actually it is questionable for product development in a commercial
environment (especially in the embedded world where you usually have a
quite defined hardware and software on your device) if one actually
wants that - think of the "if it's not broken, don't fix it" reason.

> And unless Y+15 has some *very* compelling reasons to move forward, just
> sticking at Y suddenly starts looking very good, because watching somebody
> else's kernel janitor monkeys fix your code is fairly cheap, but paying your
> own kernel janitor monkeys gets expensive really fast....

It depends on the *very* compelling reason if it is easier/cheaper to
a) fix the problem in the "old" kernel,
b) backport something or
c) forward port the own drivers/changes.
And that decision depends on lots of factors (and company-internal
bureaucracy with the QA department may not be the least important).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

