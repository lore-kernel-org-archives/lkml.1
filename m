Return-Path: <linux-kernel-owner+w=401wt.eu-S1751331AbXBMReg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbXBMReg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXBMRef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:34:35 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57287 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbXBMRef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:34:35 -0500
X-Sasl-enc: 8BKD9PBIyq7vrDfaaze/05DHLtPzsjavfsYTSb1JVATA 1171388072
Subject: Re: [PATCH 1/2] Re: [autofs] Bad race condition in the new autofs
	protocol somewhere
From: Ian Kent <raven@themaw.net>
To: Olivier Galibert <galibert@pobox.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       "Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
In-Reply-To: <20070213155405.GA33765@dspnet.fr.eu.org>
References: <20070207173414.GA64492@dspnet.fr.eu.org>
	 <1170871661.3415.36.camel@raven.themaw.net>
	 <20070207181817.GA75717@dspnet.fr.eu.org>
	 <1170901990.3383.18.camel@raven.themaw.net>
	 <1171262594.18376.13.camel@raven.themaw.net>
	 <20070212135749.GA1681@dspnet.fr.eu.org>
	 <1171327959.3377.3.camel@raven.themaw.net>
	 <20070213085053.GA74257@dspnet.fr.eu.org> <45D1C61F.9090509@redhat.com>
	 <20070213155405.GA33765@dspnet.fr.eu.org>
Content-Type: text/plain
Date: Wed, 14 Feb 2007 02:35:15 +0900
Message-Id: <1171388115.3377.23.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 16:54 +0100, Olivier Galibert wrote:
> On Tue, Feb 13, 2007 at 09:07:27AM -0500, Chuck Ebbert wrote:
> > Olivier Galibert wrote:
> > > On Tue, Feb 13, 2007 at 09:52:39AM +0900, Ian Kent wrote:
> > >> Indeed.
> > >> Which kernel can you use?
> > >> I believe that 2200 had another problem so can you use an fc5 kernel
> > >> later than that?
> > > 
> > > I've ported your patch to 2257 (nothing special, only moved lines),
> > > and it seems to work beautifully.  I'm enlarging the testing.
> > > 
> > 
> > If you get the patches into -stable they will end up in Fedora
> > kernels automatically. 2288 (based on 2.6.19) is in testing now...
> 
> Don't they require autofs5 to be of any use though?  That's not going
> to be in fc until it's out of beta I guess.

Not really?

[raven@fc6 ~]$ cat /etc/redhat-release 
Fedora Core release 6 (Zod)
[raven@fc6 ~]$ rpm -q autofs
autofs-5.0.1-0.rc3.16
[raven@fc6 ~]$ rpm -q --changelog autofs| head -10
* Sun Feb 11 2007 Ian Kent <ikent@redhat.com> - 5.0.1-0.rc3.16
- update the "task done race" patch to fix a deadlock.

* Wed Feb 07 2007 Ian Kent <ikent@redhat.com> - 5.0.1-0.rc3.14
- fix race when setting task done (bz 227268).

* Tue Jan 30 2007 Ian Kent <ikent@redhat.com> - 5.0.1-0.rc3.12
- make double quote handing consistent (at least as much as we can).
- fix handling of trailing white space in wildcard lookup (forward port bz 199720).
- check fqdn of each interface when matching export access list (bz 213700).
[raven@fc6 ~]$ 

The Rawhide or FC-6 srpm should build fine on FC5.

Ian


