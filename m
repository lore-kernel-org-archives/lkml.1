Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbXKGBEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbXKGBEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbXKGBD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:03:56 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:49273 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXKGBD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:03:56 -0500
Message-Id: <200711070103.lA713r9R010392@www262.sakura.ne.jp>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: bunk@kernel.org
Cc: darwish.07@gmail.com, pavel@ucw.cz, casey@schaufler-ca.com,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Nov 2007 10:03:53 +0900
References: <20071103164303.GA26707@ubuntu> <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu> <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org> <20071106080637.GB26163@stusta.de> <alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org> <20071106230044.GO26163@stusta.de> <alpine.LFD.0.999.0711061506550.15101@woody.linux-foundation.org> <20071107000705.GQ26163@stusta.de> <alpine.LFD.0.999.0711061626410.15101@woody.linux-foundation.org> <20071107004350.GS26163@stusta.de>
In-Reply-To: <20071107004350.GS26163@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Adrian Bunk wrote:
> How should TOMOYO implement it's "match one character" in a pattern
> (used to allow or deny access in a name-based MAC)?

TOMOYO assumes that "one character" equals to "one byte"
since TOMOYO doesn't consider encoding.

According to your definition of "character" (i.e. it may be multibyte),
TOMOYO doesn't implement "match one character" pattern.
TOMOYO implements "match one byte" pattern.

Thanks.
