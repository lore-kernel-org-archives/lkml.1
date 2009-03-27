Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZC0KMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZC0KMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZC0KLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:11:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38375 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZC0KLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:11:54 -0400
Date: Fri, 27 Mar 2009 07:11:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Alessio Igor Bogani <abogani@texware.it>,
       LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
       video4linux-list@redhat.com
Subject: Re: [PATCH] radio-mr800.c: Missing mutex include
Message-ID: <20090327071143.59619399@pedra.chehab.org>
In-Reply-To: <1237326128.2141.17.camel@tux.localhost>
References: <1237323618-6464-1-git-send-email-abogani@texware.it>
	<1237326128.2141.17.camel@tux.localhost>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 00:42:08 +0300
Alexey Klimov <klimov.linux@gmail.com> wrote:

> On Tue, 2009-03-17 at 22:00 +0100, Alessio Igor Bogani wrote:
> > radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
> > pulled in indirectly by one of the headers it already includes, the
> > right thing is to include it directly.
> 
> 
> Hello, Alessio
> 
> Patch looks okay for my eyes.
> If it useful it should be applied.
> 
> Thank you!
> 
> Mauro, if patch is okay please apply it.
> If you need my ack - here it is:
> Acked-by: Alexey Klimov <klimov.linux@gmail.com>

If the mutex.h were already included by another kernel header, I don't see why
to include it again. If a later patch remove the mutex.h from the header, then
the patch author should take care of this change anyway.

Cheers,
Mauro
