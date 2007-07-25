Return-Path: <linux-kernel-owner+w=401wt.eu-S1761983AbXGYC5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983AbXGYC5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 22:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXGYC5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 22:57:11 -0400
Received: from mail.ocs.com.au ([203.34.248.175]:60465 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbXGYC5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 22:57:10 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2007 22:57:09 EDT
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG() 
In-reply-to: Your message of "Tue, 24 Jul 2007 19:31:36 MST."
             <Pine.LNX.4.58.0707241921470.30561@shell4.speakeasy.net> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 25 Jul 2007 12:50:47 +1000
Message-ID: <21803.1185331847@ocs10w.ocs.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho (on Tue, 24 Jul 2007 19:31:36 -0700 (PDT)) wrote:
>Adding __builtin_trap after the
>asm might be an ok fix.  It will emit a spurious int 6, but that won't even be
>reached since the asm doesn't return, and it probably be less extra code than
>the loop.

int 6 is a two byte instruction, the loop generates jmp with an 8 bit
offset, also two bytes.  No change in code size.

