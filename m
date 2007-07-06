Return-Path: <linux-kernel-owner+w=401wt.eu-S1752993AbXGFWoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbXGFWoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbXGFWoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:44:08 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:39258 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbXGFWoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:44:06 -0400
To: Mike Frysinger <vapier@gentoo.org>
Cc: List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
References: <8CYT9-4Ou-23@gated-at.bofh.it> <20070705205523.GA15202@suse.de>
	<87zm2aav9h.fsf@hades.wkstn.nix>
	<200707060319.36460.vapier@gentoo.org>
From: Nix <nix@esperi.org.uk>
Emacs: because idle RAM is the Devil's playground.
Date: Fri, 06 Jul 2007 23:43:57 +0100
In-Reply-To: <200707060319.36460.vapier@gentoo.org> (Mike Frysinger's message of "Fri, 6 Jul 2007 03:19:35 -0400")
Message-ID: <87myy9b1aq.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-INFN-TO-Metrics: hades 1233; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jul 2007, Mike Frysinger spake thusly:

> On Friday 06 July 2007, Nix wrote:
>> On 5 Jul 2007, Bernhard Walle stated:
>> >                                While cmake itself isn't the problem,
>> > often, it also depends on the version of cmake that is installed. The
>> > good idea about auto* tools is the idea that you don't need to install
>> > any tools to build, just to develop. A POSIX shell and Perl should be
>> > installed everywhere ...
>>
>> You don't need Perl to run configure scripts, either, and it's only
>> recently that it started requiring a POSIX shell rather than something
>> of the calibre of Solaris's /bin/sh.
>
> since when does autotools require a POSIX shell ?

autoconf 2.55's NEWS said:

,----
| - shell functions
| 
|   Shell functions will gradually be introduced, probably starting with
|   Autotest.  If you know machines which are in use that you suspect
|   *not* to support shell functions, please run the test suite of
|   Autoconf 2.55 on it, and report the results to
|   bug-autoconf@gnu.org.
`----

but actually I'm not sure if this was ever done. That's not actually `a
POSIX shell' I suppose, but it's also not going to work on prehistoric
shells like Solaris's 1980-vintage /bin/sh.

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
