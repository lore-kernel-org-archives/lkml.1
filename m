Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbYKVSys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbYKVSys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 13:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbYKVSyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 13:54:36 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56013 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756552AbYKVSyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 13:54:33 -0500
Date: Sat, 22 Nov 2008 19:54:29 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBIFS: fix compilation warnings
Message-ID: <20081122185429.GA21433@Chamillionaire.breakpoint.cc>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org> <1227287970-14684-5-git-send-email-dedekind@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1227287970-14684-5-git-send-email-dedekind@infradead.org>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Artem Bityutskiy | 2008-11-21 19:19:26 [+0200]:

>From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>
>We print 'ino_t' type using '%lu' printk() placeholder, but this
>results in many warnings when compiling for Alpha platform. Fix
>this by adding (unsingned long) casts.
>
>Fixes these warnings:
>
>fs/ubifs/journal.c:693: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'

Wouldn't %z help? A cast sounds wrong.

Sebastian
