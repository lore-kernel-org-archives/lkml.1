Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbZEHOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbZEHOeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZEHOeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:34:09 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:49042 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbZEHOeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:34:08 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rocket tty BUG in 2.6.29 (regression)
References: <8763gcsa5e.fsf@tac.ki.iif.hu>
	<20090508110316.0116208b@lxorguk.ukuu.org.uk>
Date: Fri, 08 May 2009 16:33:57 +0200
In-Reply-To: <20090508110316.0116208b@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Fri, 8 May 2009 11:03:16 +0100")
Message-ID: <87k54roe96.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Fri, 08 May 2009 02:36:45 +0200
> Ferenc Wagner <wferi@niif.hu> wrote:
>
>> 2.6.26 works fine in our terminal server machine, but after rebooting
>> it into 2.6.29 I got the following Oops when starting screen for a
>> ttyR serial device (after unloading and reloading the rocket module
>> while trying to get some udev rename rules right):
>
> So it works the first time around, then blos up the second ? Is this
> repeatable ?

No, I didn't say this.  The first time I didn't even try, because our
software uses the persistent names, not /dev/ttyR*, but the udev
rename rules didn't fire.  So I fixed the rules, removed and
reinserted the module, then started the console multiplexer, which
provoked the bugs (all 16).  I don't think it has anything to do with
the issue, but wanted to explain the "last removed: rocket" part of
the log.

> In theory Ted is the maintainer for rocket but as I'm the one who last
> did any surgery on it this one may well be my bug.

Looks like Jiri has a handle on the problem, though.  Once you
converge on a patch and need testing, tell me.  I'm not in a hurry,
the current Debian stable kernel works OK, I tested 2.6.29 while
investigating an unrelated networking issue.
-- 
Thanks for the great support again,
Feri.
