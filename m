Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbXFZPah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbXFZPah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbXFZPaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:30:30 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:53586 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991AbXFZPa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:30:29 -0400
Date: Tue, 26 Jun 2007 17:33:59 +0200
From: DervishD <lkml@dervishd.net>
To: Matthieu CASTET <castet.matthieu@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Message-ID: <20070626153358.GA27438@DervishD>
Mail-Followup-To: Matthieu CASTET <castet.matthieu@free.fr>,
	linux-kernel@vger.kernel.org
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706221626.39969.ak@suse.de> <20070622094429.0910c7cb.randy.dunlap@oracle.com> <200706221923.02736.ak@suse.de> <20070622132810.3c758590.randy.dunlap@oracle.com> <E1I2159-0005AH-DS@flower> <20070623104303.a186c5a8.randy.dunlap@oracle.com> <pan.2007.06.23.20.24.29@free.fr> <20070626101639.GB20178@DervishD> <20070626102414.GU27862@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070626102414.GU27862@lug-owl.de>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Jan :)

 * Jan-Benedict Glaw <jbglaw@lug-owl.de> dixit:
> On Tue, 2007-06-26 12:16:39 +0200, DervishD <lkml@dervishd.net> wrote:
> >     Given that it happens too with "ldd", it really *is* that hard. I
> > don't know why still people think that /bin/sh is always /bin/bash. If
> > they want/need bash, that's ok to me, I will have it installed for such
> > tasks, but they should call it "#!/bin/bash".
> 
> ...or "#!/usr/bin/env bash" for what it's worth...  The same for plain
> `sh'.

    The "env" solution is a bit of a problem, too. Not always "env" is
installed in /usr/bin, but in /bin, so it is available even if /usr is
not still mounted. But /bin/sh is pretty standard (as it should be
/bin/bash, anyway), and it's only two chars shorter than the correct
"/bin/bash". No idea why it is not fixed.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
