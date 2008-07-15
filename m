Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYGOHh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYGOHh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYGOHhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:37:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54149 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYGOHhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:37:11 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <487C500F.8000109@garzik.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <487C09EB.1050903@garzik.org>
	 <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>
	 <487C1648.5070409@garzik.org>
	 <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>
	 <487C500F.8000109@garzik.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 00:36:58 -0700
Message-Id: <1216107418.27455.236.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 03:21 -0400, Jeff Garzik wrote:
> * forced a flag day build process change upon all distros/builders who 
> switch to >= 2.6.27.  no build script updates == non-working drivers.

Jeff, we don't usually call it a 'flag day' when it's just the normal
and uninteresting case that you update the upstream version of the
package, and you need minor tweaks to how you package it. That happens
all the time. A general rule of thumb is to stop drinking at least 4
hours before undertaking a full version upgrade of _any_ package you
maintain.

You could argue that converting a wireless driver to use mac80211 would
break ipkg distributions too. And call that a 'flag day'.

But that would be silly. Wouldn't it?

-- 
dwmw2

