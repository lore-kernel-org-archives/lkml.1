Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbYHWJxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbYHWJxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 05:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYHWJxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 05:53:41 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:6817 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbYHWJxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 05:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M+Try0Ih0VbGAFZzuW/8Q0sXwzCOFxi629+crJIyzEDHeFYVjK9E5eLnFW1zmIatfK
         oXxkG0vHx0onGFlzsnPdtlcBGSAKTZ9hEm2Vwe+7sbbgeSoscxiUTUQAWitNuAhXJSQF
         aIJ/rFmXXDGatk2ua/gIBPThBR1yzCt0arBlg=
Message-ID: <19f34abd0808230253w663722dcwde1303998e194ddf@mail.gmail.com>
Date: Sat, 23 Aug 2008 11:53:39 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Chris Frey" <cdfrey@foursquare.net>
Subject: Re: Visible Ctrl-C in latest kernels
Cc: "Joe Peterson" <joe@skyrush.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080822201537.GA18242@foursquare.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080822201537.GA18242@foursquare.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 10:15 PM, Chris Frey <cdfrey@foursquare.net> wrote:
> Hi,
>
> A fairly user-level question here.
>
> I recently upgraded from 2.6.24.3 to 2.6.26.3.
>
> I've noticed that on my Debian stable system, I can now see Ctrl-C characters
> when using an xterm.  I've checked the stty settings and nothing seems
> different.

That is a feature which was introduced in

commit ec5b1157f8e819c72fc93aa6d2d5117c08cdc961
Author: Joe Peterson <joe@skyrush.com>
Date:   Wed Feb 6 01:37:38 2008 -0800

    tty: enable the echoing of ^C in the N_TTY discipline

    Turn on INTR/QUIT/SUSP echoing in the N_TTY line discipline (e.g.  ctrl-C
    will appear as "^C" if stty echoctl is set and ctrl-C is set as INTR).

    Linux seems to be the only unix-like OS (recently I've verified this on
    Solaris, BSD, and Mac OS X) that does *not* behave this way, and I really
    miss this as a good visual confirmation of the interrupt of a program in
    the console or xterm.  I remember this fondly from many Unixs I've used
    over the years as well.  Bringing this to Linux also seems like a good way
    to make it yet more compliant with standard unix-like behavior.

    [akpm@linux-foundation.org: coding-style fixes]
    Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Are you experiencing a problem related to this?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
