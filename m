Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbXH1PR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbXH1PR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 11:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbXH1PRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 11:17:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50449 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbXH1PRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 11:17:48 -0400
Date: Tue, 28 Aug 2007 08:17:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
Message-ID: <20070828081710.4687185c@laptopd505.fenrus.org>
In-Reply-To: <200708281256.35162.vda.linux@googlemail.com>
References: <200708252257.07241.vda.linux@googlemail.com>
	<200708261621.30563.vda.linux@googlemail.com>
	<20070827020310.GC4121@stusta.de>
	<200708281256.35162.vda.linux@googlemail.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 12:56:34 +010
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> >
> >   make namespacecheck
> 
> Thanks, nice tool.
> 
> aic7xxx is kind of not very nice in this regard.
> 
> See below what I get even on non-patched driver.
> 
> I am willing to clean it up, but I still would like
> "debloating" patch to be accepted.

Fwiw I do like your debloat patch a lot; it's just only half the
equation ... if you also do the namespace fixes, I bet the driver
debloats even more...

