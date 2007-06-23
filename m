Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbXFWPie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbXFWPie (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 11:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXFWPi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 11:38:26 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:47761 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbXFWPiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 11:38:25 -0400
In-Reply-To: <20070623153239.78ee86fe@the-village.bc.nu>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706231300.22197.ak@suse.de> <200706231309.49701.arekm@maven.pl> <200706231517.28085.ak@suse.de> <20070623153239.78ee86fe@the-village.bc.nu>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <afce40b8ee50e0d7b679e9c4d604e19e@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, akpm@linux-foundation.org,
       Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Date: Sat, 23 Jun 2007 17:35:55 +0200
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Having the scripts work with other shells is very helpful for porting,
> cross building and the like.

I think it is fair game to require bash to build the
kernel -- after all, GCC and GNU make are required
already, and bash has many helpful features that not
every POSIX shell has.

> Also on Linux /bin/sh is not neccessarily /bin/bash.

Yes, it would be ridiculous to require /bin/sh to be
bash.  Especially since bash is installed as /bin/bash
always :-)


Segher

