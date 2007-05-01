Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbXEABdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbXEABdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 21:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbXEABdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 21:33:23 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34229 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbXEABdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 21:33:22 -0400
Message-ID: <463698D5.20102@zytor.com>
Date: Mon, 30 Apr 2007 18:33:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: arch/i386/boot rewrite, and all the hard-coded video cards
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm rewriting the i386 setup code in C, instead of assembly, and before
I spend a very large amount of time translating all the various
card-specific probes, I want to ask the following question...

Does *anyone* care about these anymore?

All of these are specific to cards from a very long time ago.  I am
currently planning to retain the VESA-related code, and the standard
video modes, but I'd like to avoid the card-specific stuff, especially
since I have absolutely zero ability to test any of testing them (with
the possible sole exception of the cirrus5 code, which is emulated by qemu.)

Please holler if you care...

	-hpa

