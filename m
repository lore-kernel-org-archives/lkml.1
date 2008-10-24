Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbYJXVK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbYJXVK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYJXVKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:10:48 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:2141 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYJXVKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:10:48 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: Elias Oltmanns <eo@nebensachen.de>, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch 27/27] ath5k: fix suspend-related oops on rmmod
Date: Fri, 24 Oct 2008 17:10:37 -0400
Message-Id: <20081024210333.M86486@bobcopeland.com>
In-Reply-To: <87ej253f3r.fsf@denkblock.local>
References: <20081024042023.054190751@mini.kroah.org> <20081024043530.GB30828@kroah.com> <87ej253f3r.fsf@denkblock.local>
X-Mailer: OpenWebMail 2.53 
X-OriginatingIP: 149.101.1.135 (bob)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 22:36:24 +0200, Elias Oltmanns wrote
> I've done some more testing and I'm ashamed to say that this patch is
> incomplete and does indeed introduce a regression itself. Having only
> just sent the fix to John, I'm afraid this patch has to be deferred for
> the next stable release since the required fix is not likely to hit
> Linus' tree in time. 

Yeah, let's drop the patch from stable since it resets the key cache
even in the not-opened resume case.

Note, ath5k_set_key is a no-op right now so we can just elide that
whole section of code.

-- 
Bob Copeland %% www.bobcopeland.com


