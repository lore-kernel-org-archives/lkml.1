Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbYHVPKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbYHVPKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYHVPKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:10:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1843 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750998AbYHVPKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:10:22 -0400
Date: Fri, 22 Aug 2008 17:09:17 +0200
From: Pavel Machek <pavel@suse.cz>
To: david@lang.hm
Cc: Eric Paris <eparis@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
       Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro linux interface for  for access scanning
Message-ID: <20080822150917.GA8152@ucw.cz>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com> <1219076143.15566.39.camel@localhost.localdomain> <20080818171500.78590801@lxorguk.ukuu.org.uk> <1219080504.15566.65.camel@localhost.localdomain> <20080818182556.13ced58f@lxorguk.ukuu.org.uk> <1219082097.15566.82.camel@localhost.localdomain> <20080818183540.GA5470@cs.cmu.edu> <1219085176.15566.100.camel@localhost.localdomain> <alpine.DEB.1.10.0808181159400.15109@asgard.lang.hm> <alpine.DEB.1.10.0808191906270.20991@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808191906270.20991@asgard.lang.hm>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Eric is viewing this through the AV point of view,
>   this means
...
> He is thinking that any ability to avoid doing the scan 
> is a security hole.

That's contrary to the threat model ('it is just a scanner').

(Plus you can't do it. mmap. Of course you can pass viruses between
two cooperating applications... and you can do it through filesystem,
too. And you probably can make un-cooperating network server serve
viruses, as long as the network server uses mmap.)

This is the thing that makes antivirus ugly, its unique to the
antivirus, plus it can't be done. I.e. bad goal.


							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
