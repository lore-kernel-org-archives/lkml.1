Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXDNUU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXDNUU4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 16:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXDNUU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 16:20:56 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:54876 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbXDNUUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 16:20:55 -0400
Date: Sat, 14 Apr 2007 22:20:50 +0200
From: Jan Yenya Kasprzak <kas@fi.muni.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, osv@javad.com
Subject: Re: [RFC 1/1] Char: mxser_new, fix recursive locking
Message-ID: <20070414202050.GG20376@fi.muni.cz>
References: <20070414042725.GT20376@fi.muni.cz> <462079ED.2000605@gmail.com> <3018694794025219@wsc.cz> <20070414143719.GA5203@fi.muni.cz> <4af2d03a0704140952w6e2338c4g3037f4ba03e2fb1d@mail.gmail.com> <20070414195543.GE20376@fi.muni.cz> <4af2d03a0704141311q61931b98wb613b4ee4c580b02@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4af2d03a0704141311q61931b98wb613b4ee4c580b02@mail.gmail.com>
User-Agent: Mutt/1.4.1i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 14 Apr 2007 22:20:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
: On 4/14/07, Jan Yenya Kasprzak <kas@fi.muni.cz> wrote:
: >~BUG: spinlock lockup on CPU#0, sshd/1671, ffffffff80557780
: [...]
: >the write(1, "/file/name/...", ...) call returned -EIO.
: 
: Just a question: both with mxser_new, right?

	No. One side has a multiport C168H with mxser_new, and the other
one (the one from which the above strace is) is an ordinary server with
console on ttyS0. So the above write(1,...) has fd#1 on ttyS0.

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
> I will never go to meetings again because I think  face to face meetings <
> are the biggest waste of time you can ever have.        --Linus Torvalds <
