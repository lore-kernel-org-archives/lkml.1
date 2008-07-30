Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYG3Q5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYG3Q5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYG3Q5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:57:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYG3Q5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:57:13 -0400
Subject: Re: [PATCH] mISDN cleanup user interface
From: David Woodhouse <dwmw2@infradead.org>
To: Karsten Keil <kkeil@suse.de>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
In-Reply-To: <20080730163314.GB9491@pingi.kke.suse.de>
References: <20080729195637.GB25929@pingi.kke.suse.de>
	 <1217362946.27925.137.camel@pmac.infradead.org>
	 <1217365330.417.8.camel@californication>
	 <1217409211.27925.177.camel@pmac.infradead.org>
	 <20080730163314.GB9491@pingi.kke.suse.de>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 17:57:01 +0100
Message-Id: <1217437021.3454.8.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 18:33 +0200, Karsten Keil wrote:
> What about this implementation ?

Looks a lot saner... although it does seem to confirm my earlier
suspicion that you're not even _using_ the fact that it's a bitmap at
all. You set the bits for the present channels at init time, which are
always contiguous, and you never seem to change them them later -- why
couldn't you do this with a simple 'number of channels' integer?

Are you later intending to use the bitmap to mark them as busy/free?

-- 
dwmw2

