Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbYE0VYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbYE0VYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbYE0VYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:24:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39474 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898AbYE0VYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:24:36 -0400
Subject: Re: [PATCHv2 28/28] firmware: convert korg1212 driver to use
	firmware loader exclusively
From: David Woodhouse <dwmw2@infradead.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <86802c440805271133h1f93b92fkef99f8effeaaf223@mail.gmail.com>
References: <1211708969@pmac.infradead.org>
	 <E1K0DOQ-0007Ea-GW@shinybook.infradead.org> <20080525141113.57c48bd9@core>
	 <86802c440805271133h1f93b92fkef99f8effeaaf223@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 28 May 2008 00:24:02 +0300
Message-Id: <1211923442.2462.69.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 11:33 -0700, Yinghai Lu wrote:
> any chance to make it get into 2.6.26?
> 
> before this i need to keep two copies klibc with fw (qla24xxx) in
> initramfs. one for 32 bit and one for 64 bit.

Well, it's supposedly too late, but it's dead simple and shouldn't have
much chance of breaking anything, so I suppose as long as we don't
include the korg1212 patch and the rest of the similar patches which
we're still working on, that's not such an insane request.

As long as the one or two drivers I mentioned get tested, that is.

-- 
dwmw2

