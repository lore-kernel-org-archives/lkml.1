Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab0BSMGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 07:06:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43130 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751018Ab0BSMGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 07:06:01 -0500
Date: Fri, 19 Feb 2010 12:07:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ari G. Entlich" <atrigent@ccs.neu.edu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add a new VT mode which is like VT_PROCESS but doesn't
 require a VT_RELDISP ioctl call
Message-ID: <20100219120730.4793ce0d@lxorguk.ukuu.org.uk>
In-Reply-To: <28568671.141471266580824918.JavaMail.root@zimbra>
References: <7662526.141431266580674036.JavaMail.root@zimbra>
	<28568671.141471266580824918.JavaMail.root@zimbra>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. VT_AUTO doesn't send signals to anything when a VT switch happens, precisely
>    because VT_AUTO is supposed to be used in the case where there's nothing to
>    send signals TO (i.e. the VT is managed by the kernel). The X server still
>    needs to know about VT switches to turn input devices off and such.

Ok..

> VT_ACKACQ, it wouldn't really make sense for there to be a new VT_ACKACQ value,
> because VT_ACKACQ is something which gets passed to a VT_RELDISP, and VT_RELDISP
> isn't needed at all in this new mode.

I don't want to change the existing values as they are somewhat visible
to user space.

> I hope that clarifies things.

Yes. You could use the VT_EVENT facility for the switch monitoring but
the asynchronous nature of the reporting probably isn't what is needed
for input device switching etc.

Looks fine to me - just bump the value and resubmit
