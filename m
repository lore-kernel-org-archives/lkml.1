Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbZFBOn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbZFBOn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZFBOnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:43:46 -0400
Received: from build.ossfans.org ([67.223.233.67]:57273 "EHLO
	build.ossfans.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZFBOnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:43:45 -0400
Date: Tue, 2 Jun 2009 18:43:35 +0400
From: Sergey Lapin <slapin@ossfans.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, maxim.osipov@siemens.com,
       dmitry.baryshkov@siemens.com, oliver.fendt@siemens.com
Subject: Re: [PATCH 09/10] ieee802154: add serial dongle driver
Message-ID: <20090602144335.GC13088@build.ossfans.org>
References: <1243868091-5315-4-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-5-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-6-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-7-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-8-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-9-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-10-git-send-email-dbaryshkov@gmail.com> <20090601162732.4a070c43@lxorguk.ukuu.org.uk> <20090601202946.GB7143@doriath.ww600.siemens.net> <20090601225205.1e7e8944@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601225205.1e7e8944@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > C&P from drivers/bluetooth/hci-ldisc.c, around line 466. We had problems
> > working with low-latency unset.
> 
> The bluetooth one needs killing too. I will do that tomorrow ...
> 
> How many releases ago - the entire tty buffering layer has been rewritten
> over time. tty->low_latency requires driver specific support that most
> don't have. Also as of 2.6.30rc you'll get debug spew if you misuse it.
> 
> If you still need it we need to know why.

As we're tested it here, we don't need tty->low_latency anymore.
So that can go away. Thanks!

