Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbXLBUD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbXLBUD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbXLBUDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:03:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43985 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbXLBUDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:03:48 -0500
Date: Sun, 2 Dec 2007 12:02:14 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Pavel Machek <pavel@ucw.cz>, tvrtko.ursulin@sophos.com,
       Andi Kleen <andi@firstfloor.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071202120214.68cf1700@laptopd505.fenrus.org>
In-Reply-To: <17957.1196624688@turing-police.cc.vt.edu>
References: <p738x4i9nyd.fsf@crumb.suse.de>
	<OFFB86F10D.D565B603-ON802573A2.005A558C-802573A2.005B85B0@sophos.com>
	<20071201084332.GB4446@ucw.cz>
	<17957.1196624688@turing-police.cc.vt.edu>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Dec 2007 14:44:48 -0500
Valdis.Kletnieks@vt.edu wrote:

> On Sat, 01 Dec 2007 08:43:32 GMT, Pavel Machek said:
> 
> > So what you are trying to do is 'application may never read bad
> > sequence of bits from disk', right?
> 
> No, in many of the use cases, we're trying to do "if application
> reads certain specified sequences of bits from disk we know about
> it", which is subtly different.  Often, *absolute* prevention isn't
> required, as long as we can generate audit trails and/or alerts...

.. which breaks down if/when glibc uses mmap() to implement the
fopen/fread etc interface
(note: it already does, just not quite yet by default)




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
