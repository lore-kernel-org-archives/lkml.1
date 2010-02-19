Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0BSOQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 09:16:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46296 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752766Ab0BSOQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 09:16:22 -0500
Date: Fri, 19 Feb 2010 14:18:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ari G. Entlich" <atrigent@ccs.neu.edu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add a new VT mode which is like VT_PROCESS but doesn't
 require a VT_RELDISP ioctl call
Message-ID: <20100219141829.3e6c0d8c@lxorguk.ukuu.org.uk>
In-Reply-To: <9700049.142281266585049621.JavaMail.root@zimbra>
References: <16583928.142261266584767537.JavaMail.root@zimbra>
	<9700049.142281266585049621.JavaMail.root@zimbra>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry if I was unclear - I wasn't talking about changing the value, I was
> just saying that VT_ACKACQ and VT_PROCESS_AUTO are used in different
> contexts, so it shouldn't matter that they have the same value. One thing
> that probably would be nice though would be to move the VT_ACKACQ define
> to a different place in vt.h (probably after the VT_RELDISP define).

That would just as well. It just needs to be obvious for future
maintainers that the overlap doesn't matter
