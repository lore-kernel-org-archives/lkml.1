Return-Path: <linux-kernel-owner+w=401wt.eu-S1765017AbXG1GqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765017AbXG1GqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 02:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXG1GqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 02:46:16 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45963 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754292AbXG1GqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 02:46:14 -0400
X-Sasl-enc: 3CpNzQ0UJvHe2ycRnGejb/tc/F48UoR6etJeACTkiaRa 1185605172
Subject: Re: request for patches: showing mount options
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kzak@redhat.com, ericvh@gmail.com,
       lucho@ionkov.net, zippel@linux-m68k.org, hpa@zytor.com,
       rathamahata@php4.ru, dhowells@redhat.com, sfrench@samba.org,
       mhalcrow@us.ibm.com, phillip@hellewell.homeip.net,
       hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
       wli@holomorphy.com, shaggy@austin.ibm.com, vandrove@vc.cvut.cz,
       trond.myklebust@fys.uio.no, aia21@cantab.net, mark.fasheh@oracle.com,
       kurt.hackel@oracle.com, reiserfs-devel@vger.kernel.org,
       bfennema@falcon.csc.calpoly.edu, dushistov@mail.ru,
       xfs-masters@oss.sgi.com, arnd@arndb.de, holzheu@de.ibm.com
In-Reply-To: <E1IERvH-00016M-00@dorka.pomaz.szeredi.hu>
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu>
	 <1185550256.3203.77.camel@raven.themaw.net>
	 <E1IERvH-00016M-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Sat, 28 Jul 2007 14:45:59 +0800
Message-Id: <1185605159.8326.5.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 17:40 +0200, Miklos Szeredi wrote:
> >   all - fs has options, but doesn't define ->show_options()
> >   some - fs defines ->show_options(), but some options are not shown
> >   noopt - fs does not have options
> >   good - fs shows all options
> >   patch - I have a patch
> 
> [...]
> 
> > > autofs      all
> > 
> > I'm not sure I understand this.
> > How does autofs show it's options without a ->show_options method?
> 
> It doesn't.  The "all" means, all of them need to be added to
> ->show_options(), not that all are shown.

Oh .. sorry, I wasn't paying enough attention.

But now might be a good time to propose the removal of autofs and rename
autofs4 to autofs. I would need to provide some way to map autofs4
module load requests to autofs for backward compatibility but haven't
thought about that yet.

> 
> I can see now that this is slightly confusing, sorry.
> 
> So the ones that need attention are "all" and "some".  The others are
> fine in theory.  Of course I may have missed something.
> 
> > > autofs4     some
> > 
> > OK, uid and gid aren't shown.
> > That should be straight forward to fix.
> > What's your time frame for this?
> 
> ASAP ;)
> 
> 2.6.24 would be a nice, but it won't be easy...

The autofs4 (and, if needed autofs) should be straight forward.
I'll do these.

Ian


