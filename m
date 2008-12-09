Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYLIWwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYLIWwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbYLIWwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:52:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841AbYLIWwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:52:06 -0500
Date: Tue, 9 Dec 2008 14:47:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Manfred Spraul <manfred@colorfullife.com>,
       Clement Calmels <cboulte@gmail.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>
Subject: Re: [patch 021/104] lib/idr.c: fix rcu related race with idr_find
In-Reply-To: <21d7e9970812091340p5121e8f8l1e2411035331e8d0@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0812091447230.3340@localhost.localdomain>
References: <20081203193901.715896543@mini.kroah.org>  <20081203194725.GA8950@kroah.com> <20081203194906.GV8950@kroah.com> <21d7e9970812091340p5121e8f8l1e2411035331e8d0@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Dec 2008, Dave Airlie wrote:
>
> On Thu, Dec 4, 2008 at 5:49 AM, Greg KH <gregkh@suse.de> wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> >
> Revert.
> 
> This caused problems in the F10 kernel with idr, the drm device alloc
> went all wierd,
> it might be a drm bug but changing this code triggers it and so it
> isn't really "stable"

Well, maybe it should be reverted in mainlne too, then?

		Linus
