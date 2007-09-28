Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbXI1Ijb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbXI1Ijb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbXI1IjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:39:23 -0400
Received: from ns.firmix.at ([62.141.48.66]:37008 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbXI1IjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:39:22 -0400
Subject: Re: [Announce] Linux-tiny project revival
From: Bernd Petrovitsch <bernd@firmix.at>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Indan Zupancic <indan@nul.nu>, Rob Landley <rob@landley.net>,
       Michael Opdenacker <michael@free-electrons.com>, linux-tiny@selenic.com,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200709280021.34783.arnd@arndb.de>
References: <46F1645D.9050406@am.sony.com>
	 <200709270900.36602.arnd@arndb.de>
	 <39129.81.207.0.53.1190910941.squirrel@secure.samage.net>
	 <200709280021.34783.arnd@arndb.de>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 28 Sep 2007 10:39:06 +0200
Message-Id: <1190968746.15499.4.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.314 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.314 required=5
X-Spam-Score: -2.314 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2007-09-28 at 00:21 +0200, Arnd Bergmann wrote:
> On Thursday 27 September 2007, you wrote:
> > > Then you don't have to change every single printk in the kernel, but
> > > only those that don't currently come with a log level. More importantly,
> > > you can do the conversion without a flag day, by spreading (an empty)
> > > PRINTK_CONTINUED in places that do need a printk without a log level.
> > 
> > The problem is, how do you know whether to print a continued printk or not?
> > It depends on the loglevel of the first printk.
> 
> Those need to be looked at individually. You can normally see easily from

If think you misunderstood:
Say, you compile out everything of DEBUG level.
Say, you have a continued printk() after each and every pr_debug().

Then how is the macro supposed to know (at compile-time) that the
continued printk()  actually belongs to a DEBUG printk (and not another
one)?

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


