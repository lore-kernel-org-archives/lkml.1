Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbXFDUjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbXFDUjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXFDUi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:38:58 -0400
Received: from snowcat.de ([89.31.32.98]:2352 "EHLO snowcat.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbXFDUi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:38:57 -0400
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: stallion driver dmesg notice
Organization: Disorganized
From: Ingo Korb <usenet@mail.snowcat.de>
In-Reply-To: <uvee458fa.fsf@dragon.akana.de> (Ingo Korb's message of "Mon,
 04 Jun 2007 12:19:05 +0200")
References: <46633BC8.3838.43FB8257@ml.akana.de> <304615082222625376@wsc.cz>
	<304615082222625376@wsc.cz> <21118142571565213847@wsc.cz>
	<uvee458fa.fsf@dragon.akana.de>
Date: Mon, 04 Jun 2007 22:38:53 +0200
Message-ID: <ulkez5uaq.fsf@dragon.akana.de>
User-Agent: Gnus/5.1002 (Gnus v5.10.2) Emacs/21.3 (windows-nt)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:21:070604:linux-kernel@vger.kernel.org::GJCEeJFw9QYOOd0P:000000000
	0000000000000000000000003pMD
X-Hashcash: 1:21:070604:jirislaby@gmail.com::MujdFZRT1AYMc5UD:000000000000000000
	0000000000000000000000000vdl
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Korb <usenet@mail.snowcat.de> writes:

> Loads find and seems to work with basic tests (and no character loss,
> yay!). I'll try 8-link bonded ppp when I've set up a second box.

Update: The driver now survives 7-link[1] bonded ppp without problems
with both UART types. IIRC it previously died with CD1400 and stopped
to transmit suddenly with 26C198 ("XP" panels).

Thanks!

-ik
[1] One port didn't work, but that looks like a hardware problem on the
receiving side which isn't stallion-driven.

