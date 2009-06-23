Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZFWTX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZFWTX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZFWTXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:23:18 -0400
Received: from vena.lwn.net ([206.168.112.25]:42663 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZFWTXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:23:17 -0400
Date: Tue, 23 Jun 2009 13:23:16 -0600
From: Jake Edge <jake@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       "corbet@lwn.net" <corbet@lwn.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>
Subject: Re: [PATCH v3.1415] Documentation: add documentation summary for
 rc-series and merge window
Message-ID: <20090623132316.28a4a348@chukar>
In-Reply-To: <alpine.LFD.2.01.0906231210040.3240@localhost.localdomain>
References: <20090622222217.GH23972@bombadil.infradead.org>
	<m3fxdqj2bz.fsf@lwn.net>
	<m3bpoen5pp.fsf@intrepid.localdomain>
	<20090623130602.6cd6b713@chukar>
	<alpine.LFD.2.01.0906231210040.3240@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 12:11:52 -0700 (PDT) Linus Torvalds wrote:

> In fact, this whole discussion has shown one thing: people still
> think that "bug fix" somehow automatically means that it's
> appropriate after the merge window. That's simply not so. 

Makes sense.  It certainly is counter-intuitive sometimes, though.
Just to clarify, there would seem to be one other category of bugs that
is reasonable post-merge-window: those introduced by new features (or
bug fixes) that were added during the merge window (i.e. something
found in testing the new code during the -rc cycle). Those don't
necessarily have to be security/oops problems and, for the most part,
can't be regressions (at least for new features).  Or should those
wait, by and large, for the next merge window?

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
