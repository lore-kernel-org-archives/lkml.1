Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbZEDQ0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbZEDQ0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZEDQ0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:26:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:57451 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932094AbZEDQ03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:26:29 -0400
X-Authenticated: #54312696
X-Provags-ID: V01U2FsdGVkX19Q3QZy7gJQIZfHEpNP9r2ndq+zKKF43S3Pp7MfaN
	+LMZd3JPcjkQKg
Date: Mon, 04 May 2009 18:26:28 +0200 (CEST)
Message-Id: <20090504.182628.216265620.wl@gnu.org>
To: linux-kernel@vger.kernel.org
Subject: Re: some kernel issues
From: Werner LEMBERG <wl@gnu.org>
In-Reply-To: <20090503.132958.227862405.wl@gnu.org>
References: <20090503.132958.227862405.wl@gnu.org>
X-Mailer: Mew version 6.2.50 on Emacs 22.3.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[kernel 2.6.30-rc4-14-vanilla from openSuSE factory on top of
openSuSE 11.1]


With my 945GM intel graphics card, I don't get TTYs which I could
switch to with Ctrl-Alt-Shift-F1, for example, after X has started.
Only F7 to switch back to graphics mode works fine.  In particular, I
don't see any boot messages at start-up.  This has worked fine with a
previous kernel like 2.6.27.21.

Are there new boot parameters to add or is this a bug?  It seems that
`vga=0x31a' fails (which openSuSE's yast installer provides) since
without it I can see boot messages.

BTW, for `vga=0x31a' I get

  Console: colour dummy device 80x25

in the log file, while without this parameter I get

  Console: colour VGA+ 80x25


    Werner
