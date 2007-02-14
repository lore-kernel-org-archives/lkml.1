Return-Path: <linux-kernel-owner+w=401wt.eu-S1751381AbXBNXd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbXBNXd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXBNXd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:33:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:56550 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751381AbXBNXd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:33:29 -0500
X-Provags-ID: V01U2FsdGVkX18QXxoqEsoQO3Le1lZyGkhVpBTo9amvS5oF8//toq
	7m9w==
From: Frank Hartmann <soundart@gmx.net>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.19.1 Oops while doing Disk IO + playing sound, 2.6.20 too
In-Reply-To: <20070214143249.GE23203@duck.suse.cz> (Jan Kara's message of
	"Wed, 14 Feb 2007 15:32:50 +0100")
References: <877ivr6t0k.fsf@fantasio.hh.de>
	<20070207091841.GE24590@atrey.karlin.mff.cuni.cz>
	<87wt2thhux.fsf@fantasio.hh.de> <20070208093930.GB10973@duck.suse.cz>
	<87bqk06bhi.fsf_-_@fantasio.hh.de> <20070214143249.GE23203@duck.suse.cz>
Date: Thu, 15 Feb 2007 00:33:31 +0100
Message-ID: <87r6ssl3g4.fsf@fantasio.hh.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Yes I see some correlation. Again it seems there is a problem with buffers
> attached to a page which got truncated but Private flag of the page stayed.
> It's probably not important but just out of curiosity - do you have
> CONFIG_LBD (large block device) set? I'd just like to verify that page_bufs
> was NULL when it was passed to walk_page_buffers().


fantasio:~/tmp/linux-2.6.20$ fgrep CONFIG_LBD .config
# CONFIG_LBD is not set


>   You said 2.6.17 worked for you, didn't you? How long does it take to
> reproduce the problem? If it is reasonably easy (e.g. a few hours), could
> you trace back when the problem started happening? If you could narrow that
> problem down to a single patch (using git-bisect), that would be great.

Yes I said that. At least I did not notice it happen:) 
Reproduction seems easy. So I will try. 

I have some problem: I am not sufficiently familar with git!

I found http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt
Is this the way to do a git-bisect?

>From where do I get the 'labels' for good(2.6.17) and bad(2.6.20)?

regards
  Frank
