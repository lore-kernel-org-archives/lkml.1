Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbXKLQss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbXKLQss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759352AbXKLQsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:48:32 -0500
Received: from mailout07.sul.t-online.de ([194.25.134.83]:34737 "EHLO
	mailout07.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759325AbXKLQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:48:31 -0500
X-Greylist: delayed 1427 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2007 11:48:31 EST
Message-ID: <47387E32.4050206@t-online.de>
Date: Mon, 12 Nov 2007 17:24:18 +0100
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070810)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] add -fno-tree-scev-cprop to KBUILD_CFLAGS
References: <20071111064829.GG21669@stusta.de>
In-Reply-To: <20071111064829.GG21669@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ID: TEJ6VeZawho2ML4XYQLWIpaQMB+of+1cL4OmHpgScZnyTbrUYTqdrNDLN68OKFmZ04
X-TOI-MSGID: 539d2277-f056-4333-a4bb-ef67bcb0c2ce
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> The gcc from svn that will become gcc 4.3 generates libgcc calls in 
> cases like the following (on 32bit architectures):
> 
> <--  snip  -->
> 
> static inline void timespec_add_ns(struct timespec *a, u64 ns)
> {
> ...
>         while(ns >= NSEC_PER_SEC) {
>                 ns -= NSEC_PER_SEC;
>                 a->tv_sec++;
>         }
> ...
> 
> <--  snip  -->
> 
> It can make sense to emit assembler code doing division for such C code -
> that doesn't seem to be something that would generally be wrong.

It can be a pretty huge performance regression, so gcc ought to be fixed.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
