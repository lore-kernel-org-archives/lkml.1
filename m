Return-Path: <linux-kernel-owner+w=401wt.eu-S1161268AbXCIALQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161268AbXCIALQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161349AbXCIALP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:11:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44517 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161348AbXCIALN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:11:13 -0500
Date: Thu, 8 Mar 2007 16:10:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Davide Libenzi <davidel@xmailserver.org>,
       "David M. Lloyd" <dmlloyd@flurg.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-Reply-To: <45F0A2F2.3080102@goop.org>
Message-ID: <Pine.LNX.4.64.0703081607180.10832@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
 <1173364264.6891.3.camel@localhost> <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
 <45F0A2F2.3080102@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Mar 2007, Jeremy Fitzhardinge wrote:
> 
> The difficulty is that there are 4 different formats of signal structure
> you could get: (traditional|siginfo) x (32bit|64bit).

See my suggestion of a fixed-format (and much cleaned up) pseudo-siginfo 
thing earlier in this thread, and also actually mentioned as a "good to 
do" in my original email from 2003 that did the original patch ;)

> (Hey, can you send signals by writing into the signalfd?  Very plan9...)

It's an obvious extension. Whether there is any real point to it or not, I 
dunno. After all, you could just send the signal instead.

		Linus
