Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYDCXWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYDCXWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYDCXWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:22:33 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:50175 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751787AbYDCXWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:22:32 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2008 19:22:32 EDT
X-Spam-Check-By: mail.local.tull.net
Date: Fri, 4 Apr 2008 10:13:09 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Madhou <madh2001@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: shell outputs anything typed when the kernel thinks@100%
Message-ID: <20080403231309.GB18242@tull.net>
References: <200803212211.43833.madh2001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803212211.43833.madh2001@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 10:11:43PM +0100, Madhou wrote:
> When logging in a shell, one will type his username, 'return' and then his 
> password...

It sounds like you are describing behaviour of getty, not the
shell. That's because the tty device is set to echo typed characters at
the 'login:' prompt.  After getty receives your username either it or
/bin/login will turn off the echo flag and prompt for your password.

If it's a problem for you, patch getty to turn off echo (and cooked
mode) before the 'login:' prompt and perform all keyboard input
processing and echoing in the program.

> But just after 'return' the kernel is launched into thinking for long enough 
> to the point that users who do everything fast including logging in a shell 
> let the shell display the first letters of their passwords.
> This problem tends to be critical when the user makes a demonstration to a 
> bunch of people thanks to an overhead projector.

I don't think the kernel can be blamed for this behaviour, particularly
when your password is 'qwerty'. When demonstrating, setup a demo
username so you don't have to type your own password in front of a
roomful of people.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
