Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbZLRQw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbZLRQw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZLRQwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:52:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbZLRQwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:52:22 -0500
Date: Fri, 18 Dec 2009 08:50:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mikulas Patocka <mpatocka@redhat.com>
cc: kevin granade <kevin.granade@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Valdis.Kletnieks@vt.edu, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
       dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
In-Reply-To: <Pine.LNX.4.64.0912181137140.23738@hs20-bc2-1.build.redhat.com>
Message-ID: <alpine.LFD.2.00.0912180849080.3712@localhost.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>  <20091217061229.GD3946@linux-sh.org>  <m3tyvqgfs4.fsf@intrepid.localdomain>  <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>  <24653.1261110557@localhost>
 <m3my1g1hmr.fsf@intrepid.localdomain> <7004b08e0912180652p42777da3h70906f2fbdb60a69@mail.gmail.com> <Pine.LNX.4.64.0912181137140.23738@hs20-bc2-1.build.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Mikulas Patocka wrote:
>
> But think what happens when someone views that 100-char code on 80-char 
> terminal (or for example 94-char, that I used for some times too) --- 
> every second line will be wasted with just 20 characters on the left.

What kind of CRAZY crap argument is that?

The current rule is 80 characters - but how many lines are actually even 
close to 80 characters long? Very few.

So that "every second line" statement is pure and utter idiocy. Instead, 
what you get is totally the reverse: instead of wasting two lines _anyway_ 
due to a hard-newline, you often get a single line instead (since most of 
us don't work in 24x80 windows to begin with).

			Linus
