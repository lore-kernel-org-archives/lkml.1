Return-Path: <linux-kernel-owner+w=401wt.eu-S1761205AbYENReP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761205AbYENReP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756462AbYENRd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:33:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755970AbYENRd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:33:59 -0400
Date: Wed, 14 May 2008 10:32:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: maximilian attems <max@stro.at>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, Mike Frysinger <vapier@gentoo.org>,
       debian-kernel@lists.debian.org
Subject: Re: asm-{alpha,h8300,um,v850,xtensa}/param.h: unbreak HZ for
 userspace
Message-Id: <20080514103221.5ce3059c.akpm@linux-foundation.org>
In-Reply-To: <20080514110531.GA11775@stro.at>
References: <200805100836.48046.vapier@gentoo.org>
	<20080514110531.GA11775@stro.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 13:05:31 +0200 maximilian attems <max@stro.at> wrote:

> without it currently perl 5.10 doesn't build on alpha:
> perl.c: In function 'perl_construct':
> perl.c:388: error: 'CONFIG_HZ' undeclared (first use in this function)
> -> http://buildd.debian.org/fetch.cgi?pkg=perl;ver=5.10.0-10;arch=alpha;stamp=1210252894

um, that was a fairly important piece of information which was cruelly
hidden from us - thanks.

I happened to have already planned on sending this fix in for 2.6.26
but it wasn't an obvious call.
