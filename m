Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYCYOsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYCYOsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYCYOsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:48:03 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1363 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754293AbYCYOsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:48:01 -0400
Date: Tue, 25 Mar 2008 15:47:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, ebiederm@xmission.com,
       xemul@openvz.org, sds@tycho.nsa.gov, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080325144753.GA4128@ucw.cz>
References: <20080323135110.GA294@tv-sign.ru> <20080324152906.dee7b272.akpm@linux-foundation.org> <20080324225611.GA157@tv-sign.ru> <20080324160819.cea2d921.akpm@linux-foundation.org> <87r6dzi0mw.fsf@basil.nowhere.org> <m3fxuedh3m.fsf@maximus.localdomain> <20080325142259.GO2170@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325142259.GO2170@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I like the general idea -- i used to patch kernels to allow this too,
> > > but it is dangerous.
> > 
> > Though root-only. Root doesn't want to be limited and knows better
> > anyway. 
> 
> The problem is that you can deadlock if you are not very careful.

How is that different from ptracing any other process with _lot_ of
children -- like X? You'll get same zombies in both cases, leading to
same issues, no?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
