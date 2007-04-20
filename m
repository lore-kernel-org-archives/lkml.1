Return-Path: <linux-kernel-owner+w=401wt.eu-S2993070AbXDTOMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993070AbXDTOMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 10:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993254AbXDTOMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 10:12:55 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:53152 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993070AbXDTOMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 10:12:54 -0400
Date: Fri, 20 Apr 2007 16:12:45 +0200
From: Jan Yenya Kasprzak <kas@fi.muni.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Char: mxser_new, fix TIOCMIWAIT
Message-ID: <20070420141245.GP22955@fi.muni.cz>
References: <20225157853131727049@wsc.cz> <28817262632084312972@wsc.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28817262632084312972@wsc.cz>
User-Agent: Mutt/1.4.1i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 20 Apr 2007 16:12:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
: mxser_new, fix TIOCMIWAIT
: 
: There was schedule() missing in the TIOCMIWAIT ioctl. Solve it by moving
: the code to the wait_event_interruptible.

	OK, this fixed the problem with your DCD-change monitoring
program (sorry that it took me too long to test it).

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
> I will never go to meetings again because I think  face to face meetings <
> are the biggest waste of time you can ever have.        --Linus Torvalds <
