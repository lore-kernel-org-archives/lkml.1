Return-Path: <linux-kernel-owner+w=401wt.eu-S1161206AbXD1HD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161206AbXD1HD3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161356AbXD1HD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:03:29 -0400
Received: from gw.goop.org ([64.81.55.164]:54112 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161206AbXD1HD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:03:27 -0400
Message-ID: <4632F1C2.9040104@goop.org>
Date: Sat, 28 Apr 2007 00:03:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized spinlock.
 was: Re: 2.6.21-rc7-mm2
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070426182519.GA4532@gollum.tnic> <20070427172230.94b82829.akpm@linux-foundation.org> <20070428055740.GA4957@gollum.tnic> <20070428062516.GB4957@gollum.tnic>
In-Reply-To: <20070428062516.GB4957@gollum.tnic>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Sorry, no such thing in the docs to do
>
> spinlock_t __attribute__((__uninitialized__)) *ptl;
>
> in order to suppress warnings. But if function size is our concern here, even
> shorter would be:
>   

asm("" : "=rm" (ptl)) would do the job, I think, but it's pretty ugly
syntactically.

    J
