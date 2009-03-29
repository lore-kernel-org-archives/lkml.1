Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZC2PuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZC2PuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZC2PuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:50:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:51334 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZC2PuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:50:00 -0400
Date: Sun, 29 Mar 2009 08:51:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to debug kernel startup time?
Message-ID: <20090329085119.0c93fb21@infradead.org>
In-Reply-To: <4e5e476b0903290840o453bcccdm5800a636078fde6e@mail.gmail.com>
References: <4e5e476b0903290840o453bcccdm5800a636078fde6e@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009 17:40:10 +0200
Corrado Zoccolo <czoccolo@gmail.com> wrote:

> Hi,
> I'm seeing around 2 s "lost" during kernel boot, that are not
> accounted for any init call (excerpt of dmesg with initcall_debug
> follows, kernel is 2.6.29).
> What's the suggested way to investigate such problems?

I take it you don't have an initrd ?

If so I know what you are hitting; I have a patch to solve it but it's
a bit convoluted and not ready for mainline.... let me know if you want
to try it, I suspect it'll solve your issue ;)
