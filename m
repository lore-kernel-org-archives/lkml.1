Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZIEWQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZIEWQr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 18:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZIEWQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 18:16:44 -0400
Received: from vena.lwn.net ([206.168.112.25]:41344 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbZIEWQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 18:16:44 -0400
Date: Sat, 5 Sep 2009 16:16:45 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH v2] viafb: 2D engine rewrite (and viafb patches in
 general)
Message-ID: <20090905161645.74a49a84@bike.lwn.net>
In-Reply-To: <1252097032-3568-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1251666438-5448-1-git-send-email-FlorianSchandinat@gmx.de>
	<1252097032-3568-1-git-send-email-FlorianSchandinat@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Sep 2009 20:43:52 +0000
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> This patch is a completly rewritten 2D engine. The engine is no longer
> in a default state but reinitialized every time to allow usage for both
> framebuffers regardless of their settings.
> The whole engine handling is concentrated in a big function which takes
> 16 parameters.

Ouch, that's a lot of parameters.  Might it be better to create a
structure to encapsulate all of those drawing parameters?

On a more general level: is anybody maintaining a tree for patches to
the viafb driver?  I'm going to be doing some work here (writing a
driver for the video capture engine), and there's patches sitting in
Harald's tree and the OLPC tree.  It seems like a central merge point
might be a nice thing to have.

I'd be happy to run such a tree.  I'm really *not* qualified to be
passing judgment on patches to the framebuffer driver at this point,
though, so I'm not sure that I'm the best person for the job.

jon
