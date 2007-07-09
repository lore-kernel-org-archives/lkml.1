Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbXGIOqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbXGIOqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXGIOqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:46:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47894 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbXGIOqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:46:35 -0400
Subject: Re: PI mutex support on ARM
From: Arjan van de Ven <arjan@infradead.org>
To: linux@bohmer.net
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <3efb10970707081317k22de079dr9a5cad6a42cf5b3b@mail.gmail.com>
References: <3efb10970707080124i7a9323c5o9257b4adcb2ac493@mail.gmail.com>
	 <20070708095841.GA4601@elte.hu>
	 <3efb10970707081317k22de079dr9a5cad6a42cf5b3b@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 09 Jul 2007 07:46:06 -0700
Message-Id: <1183992366.2668.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-08 at 22:17 +0200, Remy Bohmer wrote:
> Hello Ingo,
> 
> > patch format problem: never diff the asm/ files, diff the asm-arm/ files.
> Yeah, of course, I know, I believe I made a real mess of this one ...
> 
> > is it safe to do a get_user() with irqs off?
> rhetorical question ;-))
> I was wondering, Is it safe to use a normal spinlock here, like this?

if get_user() isn't allowed with irq's off (and in general it's not,
maybe arm is special) then it also isn't allowed with spinlocks held..



