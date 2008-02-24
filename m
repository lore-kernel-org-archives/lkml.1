Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbYBXQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbYBXQeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbYBXQeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:34:04 -0500
Received: from 87-237-56-54.northerncolo.co.uk ([87.237.56.54]:44727 "EHLO
	totally.trollied.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYBXQeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:34:03 -0500
Date: Sun, 24 Feb 2008 16:32:40 +0000
From: John Levon <levon@movementarian.org>
To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080224163240.GA30518@totally.trollied.org.uk>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <20080223113724.GB31304@elte.hu> <20080223135335.GA28464@totally.trollied.org.uk> <20080224131001.GA7150@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224131001.GA7150@mit.edu>
X-Url: http://www.movementarian.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 08:10:02AM -0500, Theodore Tso wrote:

> > Firstly, the distributions should have set this up automatically. That
> > they don't is a distributor bug. The sheer madness of Linux not leaving
> > a vmlinux file in a stable known location is hardly something oprofile
> > can be blamed for.
> 
> Wrong Answer.  People who write userspace helpers *have* to do the
> work of the distro's.  It's a bad, bad, bad, Bad, BAD idea to leave it
> up to the distributions.  It means that some distributions won't get
> it right; other distributions will do it in different ways, making it
> harder for users to switch between distro's and making it harder for
> people to write distribution-neutral HOWTO's.

Hi Ted. I would have loved to have fixed it myself, or had one of the
other oprofile contributors do so. Unfortunately I have no control over
what the distributions do. For example:

https://bugzilla.redhat.com/show_bug.cgi?id=139767

> There are plenty of things that can be done, including using search
> paths to try to find vmlinuz; or maybe even proposing a new standard
> such as say for example /lib/modules/`uname -r`/vmlinux being a

At the time when I was trying to fix this, I wasn't aware of any way to
propose a new standard and get distributions to follow it - is there
some way now? Informally I discussed this problem several times with
many people without any resolution. As regards searching informal paths,
this is extremely risky - get the wrong vmlinux and we end up with
inaccurate results, which is worse than no results.

> The abdication of responsibility and the lack of trying to solve the
> usability issues is one of the things that really worries me about
> *all* of Linux's RAS tools.  We can and should do better!  And it's
> really embarassing that the RAS maintainers seem (I assume you are one
> of the oprofile maintainers), seem to be blaming this on the victims,
> the people who are complaining about using *your* tool.  Yes, it's a

I'm not abdicating responsibility: I no longer maintain oprofile,
haven't for a long time, and the other contributors don't have any real
time to spend on it either.  I'm well aware there are improvements to be
made: when I (and others) had time, this stuff was improving massively
with each release. When Soren et al had a need for a simple tool + GUI,
they should have helped out with this: it's simply good engineering to
not duplicate efforts. I didn't even get a /single/ email.

regards,
john
