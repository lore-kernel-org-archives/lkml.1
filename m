Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbZGJJI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbZGJJI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZGJJIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:08:11 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:56644 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZGJJIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:08:10 -0400
Date: Fri, 10 Jul 2009 11:07:53 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH 0/3] Fix sysrq caused USB performance regressions and
 leak
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <1247154399l.14017l.2l@i-dmzi_al.realan.de>
	<20090710010245.17bd0958@lxorguk.ukuu.org.uk>
In-Reply-To: <20090710010245.17bd0958@lxorguk.ukuu.org.uk> (from
	alan@lxorguk.ukuu.org.uk on Fri Jul 10 02:01:37 2009)
X-Mailer: Balsa 2.3.14
Message-Id: <1247216873l.25954l.0l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-07-10 02:01:37, Alan Cox wrote:
> > shouldn't it be
> > +	if (likely(!port->console || !port->sysrq))
> > respectively
> > +	if (unlikely(port->console && port->sysrq)) {
> > 
> > at least for clarity?
> 
> It'll get predicted by the CPU just fine I suspect.

I thought likely() / unlikely() were for the _compiler_ to arrange the
blocks more efficiently?

Anders

