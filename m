Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbZLRQnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbZLRQnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZLRQnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:43:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbZLRQni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:43:38 -0500
Date: Fri, 18 Dec 2009 11:43:23 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: kevin granade <kevin.granade@gmail.com>
cc: Krzysztof Halasa <khc@pm.waw.pl>, Valdis.Kletnieks@vt.edu,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
In-Reply-To: <7004b08e0912180652p42777da3h70906f2fbdb60a69@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0912181137140.23738@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
  <20091217061229.GD3946@linux-sh.org>  <m3tyvqgfs4.fsf@intrepid.localdomain>
  <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com> 
 <24653.1261110557@localhost> <m3my1g1hmr.fsf@intrepid.localdomain>
 <7004b08e0912180652p42777da3h70906f2fbdb60a69@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note: I'm not specifically arguing for keeping the 80-column rule, the
> project I work on uses 100 columns, and that's quite workable, but I
> haven't had any problem working with 80 columns as a limit either.  I
> do however think that just removing the limit without replacing it
> with something better is a bad idea.
> 
> -Kevin Granade

But think what happens when someone views that 100-char code on 80-char 
terminal (or for example 94-char, that I used for some times too) --- 
every second line will be wasted with just 20 characters on the left. On 
the other hand, if you have unlimited line length, it will look better on 
80-char terminal.

Mikulas
