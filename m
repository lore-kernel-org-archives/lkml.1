Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbXLRRM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbXLRRM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbXLRRMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:12:18 -0500
Received: from [194.117.236.238] ([194.117.236.238]:33913 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbXLRRMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:12:17 -0500
Date: Tue, 18 Dec 2007 19:11:22 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071218191122.6ea75867@linux360.ro>
In-Reply-To: <20071218154351.GC3974@ucw.cz>
References: <20071214004710.03f37774@linux360.ro>
	<20071218154351.GC3974@ucw.cz>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 15:43:52 +0000
Pavel Machek <pavel@ucw.cz> wrote:

> On Fri 2007-12-14 00:47:10, Eduard-Gabriel Munteanu wrote:
> 
> > +static int __cpuinit force_amd_c1e(char *str) {
> 
> { on new line, please.
> 
> > +	disable_amd_c1e = 0;
> > +	return 1;
> > +}

Sorry, I know it's a bad habit. I'll be more careful next time. Thanks
for pointing it out, though.

Anyway, there's no point in resubmitting a corrected patch, as we
already discussed that this approach isn't helpful.
