Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYBQPaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYBQPaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 10:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbYBQPaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 10:30:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56930 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYBQPaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 10:30:05 -0500
Date: Sun, 17 Feb 2008 07:29:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What's needed for a PCIe card to be recognized?
Message-ID: <20080217072927.4b6c5964@laptopd505.fenrus.org>
In-Reply-To: <20080217133753.661cd98d@bluebox.local>
References: <20080216225932.22460d31@dilbert.local>
	<20080216143946.6d532a41@laptopd505.fenrus.org>
	<20080217015453.2a4e4142@dilbert.local>
	<20080216182939.061c7246@laptopd505.fenrus.org>
	<20080217133753.661cd98d@bluebox.local>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 13:37:53 +0100
"Hans J. Koch" <hjk@linutronix.de> wrote:
> > Of course there's no driver for the wlan, but that's a different
> > story ;)
> 
> I replaced that unsupported Atheros 5007 card with an ipw3945, so I
> haven't got that problem.

oh but then you have a MUCH bigger problem ;(
The bios of that animal is hardcoded to the 5007 (or at least Atheros).
If you stick your own card in, for FCC reasons, the bios refuses the card.
(this is not unique to Asus; all notebooks do this for cards they're
not certified with. This apparently  has to do with the antenna being
part of the laptop, and thus part of the radio in FCC speak)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
