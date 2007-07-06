Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbXGFGmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbXGFGmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 02:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762064AbXGFGmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 02:42:10 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:51096 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760689AbXGFGmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 02:42:08 -0400
To: List util-linux-ng <util-linux-ng@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
References: <8CYT9-4Ou-23@gated-at.bofh.it> <8Dh9k-8lT-3@gated-at.bofh.it>
	<8DtDz-3xC-15@gated-at.bofh.it> <E1I6SfW-0002XG-AM@be1.lrz>
	<20070705192002.GB11204@DervishD> <87vecyeg5y.fsf@hades.wkstn.nix>
	<20070705205523.GA15202@suse.de>
From: Nix <nix@esperi.org.uk>
Emacs: featuring the world's first municipal garbage collector!
Date: Fri, 06 Jul 2007 07:42:02 +0100
In-Reply-To: <20070705205523.GA15202@suse.de> (Bernhard Walle's message of "Thu, 5 Jul 2007 22:55:24 +0200")
Message-ID: <87zm2aav9h.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc.uncw.edu-Metrics: hades 1201; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Jul 2007, Bernhard Walle stated:

> * Nix <nix@esperi.org.uk> [2007-07-05 22:42]:
>> 
>> My only real grouch with cmake is that the authors have invented a
>> language with so bloody many capital letters in it. 
>
> The real problem I see with cmake is that you need to have cmake
> installed on the build system.

I don't see that as being very much more of a problem than having make
installed (except of course that make is defined by POSIX and cmake is
not). The real problem is that nearly all the cmake macros are shipped
with cmake itself, so version-dependent scripts are more common, and
instead of being hit with `you need at least this version of GNU make,
released in 1998' you're likely to get hit with `you need at least this
version of cmake, released three months ago' which is more likely to
annoy the poor users.

>                                While cmake itself isn't the problem,
> often, it also depends on the version of cmake that is installed. The
> good idea about auto* tools is the idea that you don't need to install
> any tools to build, just to develop. A POSIX shell and Perl should be
> installed everywhere ...

You don't need Perl to run configure scripts, either, and it's only
recently that it started requiring a POSIX shell rather than something
of the calibre of Solaris's /bin/sh.



(But I'm spamming this list so I'll shut up now.)
