Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0BSNK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 08:10:58 -0500
Received: from zimbra.ccs.neu.edu ([129.10.116.59]:35170 "EHLO
	zimbra.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0BSNK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 08:10:56 -0500
Date: Fri, 19 Feb 2010 08:10:49 -0500 (EST)
From: "Ari G. Entlich" <atrigent@ccs.neu.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <9700049.142281266585049621.JavaMail.root@zimbra>
In-Reply-To: <16583928.142261266584767537.JavaMail.root@zimbra>
Subject: Re: [PATCH] Add a new VT mode which is like VT_PROCESS but doesn't
 require a VT_RELDISP ioctl call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [129.10.223.88]
X-Mailer: Zimbra 5.0.22_GA_3210.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.22_GA_3210.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Alan Cox" <alan@lxorguk.ukuu.org.uk> wrote:
> I don't want to change the existing values as they are somewhat visible
> to user space.

Sorry if I was unclear - I wasn't talking about changing the value, I was
just saying that VT_ACKACQ and VT_PROCESS_AUTO are used in different
contexts, so it shouldn't matter that they have the same value. One thing
that probably would be nice though would be to move the VT_ACKACQ define
to a different place in vt.h (probably after the VT_RELDISP define).

> Yes. You could use the VT_EVENT facility for the switch monitoring but
> the asynchronous nature of the reporting probably isn't what is needed
> for input device switching etc.

Yeah, it looks like the X server would have to be constantly blocking
inside a VT_WAITEVENT ioctl in order to use that, and then it wouldn't
be getting anything else done. :-/

Ari
