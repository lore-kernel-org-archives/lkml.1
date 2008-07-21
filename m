Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbYGUJI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbYGUJI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYGUJIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:08:52 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55630 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbYGUJIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:08:51 -0400
Subject: Re: [PATCH 2/8] slub: Replace ctor field with ops field in
	/sys/slab/*
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, riel@redhat.com
In-Reply-To: <87tzellqf9.fsf@devron.myhome.or.jp>
References: <Pine.LNX.4.64.0807191530100.13345@sbz-30.cs.Helsinki.FI>
	 <87tzellqf9.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Jul 2008 12:08:38 +0300
Message-Id: <1216631318.19173.31.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Pekka J Enberg <penberg@cs.helsinki.fi> writes:
> > +	if (s->ctor) {
> > +		x += sprintf(buf + x, "ctor : ");
> > +		x += sprint_symbol(buf + x, (unsigned long)s->ctor);
> > +		x += sprintf(buf + x, "\n");

﻿On Sun, 2008-07-20 at 02:44 +0900, OGAWA Hirofumi wrote:
> How about new "%pS" like following for it? If CONFIG_KALLSYMS=n, it has
> difference though...
> 
> 		x += sprintf(buf + x, "ctor : %pS\n", (unsigned long)s->ctor);

Looks good to me. I'd prefer to wait until this patchset is merged and
do all of mm/slub.c in one go.

		Pekka

