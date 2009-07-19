Return-Path: <linux-kernel-owner+w=401wt.eu-S1751201AbZGSTjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbZGSTjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 15:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZGSTjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 15:39:20 -0400
Received: from pond.fysh.org ([166.84.7.109]:44636 "EHLO pond.fysh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZGSTjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 15:39:19 -0400
Date: Sun, 19 Jul 2009 20:39:17 +0100
From: Athanasius <link@miggy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Athanasius <link@miggy.org>, Julien TINNES <jt@cr0.org>,
       Greg KH <gregkh@suse.de>, Tavis Ormandy <taviso@sdf.lonestar.org>,
       Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
       Eugene Teo <eugene@redhat.com>
Subject: Re: [link@miggy.org: Re: [patch 2/8] personality: fix
	PER_CLEAR_ON_SETID (CVE-2009-1895)]
Message-ID: <20090719193917.GK6722@miggy.org>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Athanasius <link@miggy.org>, Julien TINNES <jt@cr0.org>,
	Greg KH <gregkh@suse.de>, Tavis Ormandy <taviso@sdf.lonestar.org>,
	Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
	Eugene Teo <eugene@redhat.com>
References: <20090718202512.GA19587@suse.de> <alpine.LFD.2.01.0907181342500.13838@localhost.localdomain> <20090718212812.GI6722@miggy.org> <4A6278FD.20807@cr0.org> <20090719122701.GJ6722@miggy.org> <alpine.LFD.2.01.0907191219230.13838@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907191219230.13838@localhost.localdomain>
X-gpg-fingerprint: E218CE1D
X-gpg-key: http://www.fysh.org/~athan/gpg-key
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 19, 2009 at 12:27:05PM -0700, Linus Torvalds wrote:
> On Sun, 19 Jul 2009, Athanasius wrote:
> > 
> >   And it's that "as long as we ..." that still bothers me.  I've *never*
> > had any need for any use of this personality feature and this net/tun.c
> > exploit has proven there can be security gotchas with it.
> 
> I do agree. Some of those features may not be worth the cost.
> 
...
> 
> So I do agree that we can probably get rid of some really dated 
> personality bits. But I don't think we can really get rid of the concept. 
> Because compatibility is always of paramount importance.

  Would you agree that having these features default-off would be best?
That way a user or sysadmin isn't suddenly surprised by different
behaviour.  And those users who do need the functionality can turn it
on.  Whether that be via compile-time option or a sysctl I leave up to
the people who know more about Linux Kernel coding than I.  However, I'd
guess in the interests of vendor-kernel flexibility it should tend
towards the latter.
  And, of course, this is what I *thought* Execution Domains were for
when looking at the code.  Have only the default one and you're limited
pretty much to 'vanilla Linux'.  Actually have available a module for
another personality and you allow its selection by users.

  Put the choice in the hands of all users (read sysadmins even if its
their personal machine) rather than only in the hands of those who can
be bothered to recompile the kernel with an option, and currently
needing to hand-edit the source themselves to change the behaviour.

-- 
- Athanasius = Athanasius(at)miggy.org / http://www.miggy.org/
                  Finger athan(at)fysh.org for PGP key
	   "And it's me who is my enemy. Me who beats me up.
Me who makes the monsters. Me who strips my confidence." Paula Cole - ME
