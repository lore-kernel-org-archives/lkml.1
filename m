Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbXHUHa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbXHUHa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbXHUHaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:30:14 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:64694 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbXHUHaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:30:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=muBDaQxmgLtPWwt14DydY4to5ppsJeFn/8uiNJ0sRDbbSVVm56K26YuHlu+kuk0dM/ULrVcVbTgMHXwr4iaLtx6O8OBGNFA7La8DUZ1eCzyN6khOydYkaLFwLCabyrCIBQkbxexaHl4G+BpKlAs4KmGiSjpOMhV9pnNCcat0CEE=
Message-ID: <5d6222a80708210030w26294b0dq4bd1977fcb3bc6f4@mail.gmail.com>
Date: Tue, 21 Aug 2007 04:30:10 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt issue
Cc: "Chris Wright" <chrisw@sous-sol.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Andi Kleen" <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <46C9317C.2080509@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809241.425881000@suse.de>
	 <20070809124132.C794A14F3B@wotan.suse.de> <46C637B7.30200@goop.org>
	 <1187574628.19435.29.camel@localhost.localdomain>
	 <20070820020732.GA3672@sequoia.sous-sol.org>
	 <46C9317C.2080509@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Chris Wright wrote:
> > That did get backed out (at least the part that broke paravirt patching)
> > in 602033ed5907a59ce86f709082a35be047743a86.  Linus' tree should be
> > working fine right now with d34fda4a84c18402640a1a2342d6e6d9829e6db7
> > committed, and can be further refined with the patch below that's just
> > waiting on some further testing.
> >
>
> I don't think this is necessary.  It isn't worth complicating the
> interface to avoid the memcpy.
>
>     J
Damn,

I can't believe I've just lost a night tracking the issue, without
seeing the discussion here ;-)
I came out to this very same conclusion, and was about to send a patch
that fixes it, by doing a memcpy before starting the instruction
replacement.

(I wouldn't say anything, as this is solved, but my night have to get
some value, after all! ;-)

So I'm with Jeremy. We don't lose too much by putting a memcpy there,
this code is not exactly critical. It also seems cleaner, and less
error prone. I have a patch ready here, but I think by this time, you
guys have too ;-)

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
