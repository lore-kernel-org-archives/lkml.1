Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbYHOHKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbYHOHKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 03:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYHOHKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 03:10:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1460 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751635AbYHOHKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 03:10:45 -0400
Date: Thu, 14 Aug 2008 13:12:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: Kenneth Goldman <kgoldman@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
Message-ID: <20080814111210.GI6995@ucw.cz>
References: <20080812193031.GD18034@infradead.org> <OF6C940C00.249617D7-ON852574A3.0071F8B0-852574A3.00732160@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF6C940C00.249617D7-ON852574A3.0071F8B0-852574A3.00732160@us.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > And what happens when the chip simply goes away due to a hotplug action?
> > Or not even the actual chip goes away but just the chip driver and you
> > now dereference freed memory?
> 
> Being a TCG/TPM person, I can only address the first question.  The
> intent is that the TPM is soldered to the planar/motherboard (the TCG
> uses the phrase "bound to the platform").  I can't imagine
> any manufacturer designing a pluggable TPM.  It would subvert PCR

Only 2 TPMs I've seen were on pluggable modules... which was fortunate
because they slowed down boot by 5+ minutes, and broke it completely
in other cases. Nickname 'kurvitko' (aka useless trash that breaks
stuff). They are currently lying under my table, disconnected.

(OTOH they were not on PCI, but on some low-count pin header).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
