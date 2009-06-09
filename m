Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZFIBo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZFIBo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 21:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZFIBot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 21:44:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZFIBot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 21:44:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: PTRACE_ATTACH && -EINTR
In-Reply-To: Oleg Nesterov's message of  Monday, 8 June 2009 20:36:27 +0200 <20090608183627.GA14734@redhat.com>
References: <20090608161204.GA3986@redhat.com>
	<20090608173944.B57EBFC3C6@magilla.sf.frob.com>
	<20090608183627.GA14734@redhat.com>
X-Zippy-Says: Being a BALD HERO is almost as FESTIVE as a TATTOOED KNOCKWURST.
Message-Id: <20090609014449.8BE46FC3C6@magilla.sf.frob.com>
Date: Mon,  8 Jun 2009 18:44:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It was renamed in -next. Should I send these fixes now for 2.6.20, or we can
								 30
> wait for 2.6.31 ?

IMHO they should go in ASAP since we know this is a regression just
introduced in 2.6.29.  To me, the fact that nobody has noticed yet
makes it more important not to delay--this new problem is so obscure
that whoever is affected by it is likely to waste a lot of time figuring
out what has started happening deep down in a huge pile of userland code.


Thanks,
Roland
