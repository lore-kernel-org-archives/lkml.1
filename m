Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbXITV3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbXITV3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbXITV3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:29:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbXITV3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:29:34 -0400
From: Andreas Schwab <schwab@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-serial@vger.kernel.org
Subject: Re: Don't cross the (tty) streams
References: <20070920210221.GC10625@parisc-linux.org>
X-Yow: ..  over in west Philadelphia a puppy is vomiting..
Date: Thu, 20 Sep 2007 23:29:31 +0200
In-Reply-To: <20070920210221.GC10625@parisc-linux.org> (Matthew Wilcox's
	message of "Thu\, 20 Sep 2007 15\:02\:22 -0600")
Message-ID: <jer6ktt490.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> Connect two machines with a serial cable.  On the victim:
>
> willy@rowlf:~$ cat </dev/ttyS1
>
> Now, let's find out which ttyS on the other machine is connected ...
>
> willy@teeth:~$ echo foo >/dev/ttyS1
> -bash: echo: write error: Input/output error
>
> Oops, that's not a serial port.  No output on rowlf, as expected.
> OK, carrying on ...
>
> willy@teeth:~$ echo bar >/dev/ttyS0
>
> And yet on rowlf, we now see:
>
> foo
> bar
>
> Looks like there's an error path that doesn't throw away data on -EIO.

Read the thread starting here:
<http://lists.gnu.org/archive/html/bug-bash/2007-09/msg00020.html>.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
