Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZG0S2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZG0S2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZG0S2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:28:54 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:39568 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZG0S2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:28:53 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
References: <20090725150510.35e8854d@lxorguk.ukuu.org.uk>
	<87ab2sx15g.fsf@devron.myhome.or.jp>
	<20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker>
X-Yow: Why are these athletic shoe salesmen following me??
Date: Mon, 27 Jul 2009 20:28:46 +0200
In-Reply-To: <20090727161424.GA4233@skywalker> (Aneesh Kumar K. V.'s message
	of "Mon, 27 Jul 2009 21:44:24 +0530")
Message-ID: <m2vdle2d5t.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.96 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> I still have the "compile in emacs" bug. So this patch along with
> http://article.gmane.org/gmane.linux.kernel/869824 doesn't fix the
> bug for me.

The expect testcase still fails, too.

Andreas.

$ cat pty.tcl
#!/usr/bin/expect -f
spawn sh -c "echo foo bar"
expect {
    "foo bar" {puts $expect_out(buffer)}
}
$ expect -f pty.tcl
spawn echo foo bar

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
