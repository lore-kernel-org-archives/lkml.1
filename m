Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbYICN0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbYICN0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYICN0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:26:18 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:30394 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYICN0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:26:17 -0400
From: Andrey Mirkin <major@openvz.org>
To: Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [Devel] Re: [RFC v2][PATCH 4/9] Memory management - dump state
Date: Wed, 3 Sep 2008 17:29:11 +0400
User-Agent: KMail/1.8.2
Cc: devel@openvz.org, Oren Laadan <orenl@cs.columbia.edu>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, jeremy@goop.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <200809031543.24001.amirkin@parallels.com> <48BE7FDF.3080202@fr.ibm.com>
In-Reply-To: <48BE7FDF.3080202@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031729.14548.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 16:15 Cedric Le Goater wrote:
> Andrey Mirkin wrote:
> > On Sunday 31 August 2008 21:34 Cedric Le Goater wrote:
> >> Oren Laadan wrote:
> >>> Dave, Serge:
> >>>
> >>> I'm currently away so I must keep this short. I think we have so far
> >>> more discussion than an actual problem. I'm happy to coordinate with
> >>> every interested party to eventually see this work go into main stream.
> >>
> >> thanks. We do need a moderator and federator.
> >>
> >>> My only concerns are twofold: first, to get more feedback I believe we
> >>> need to get the code a bit more usable; including FDs is an excellent
> >>> way to actually do that. That will add significant value to the patch.
> >>
> >> hmm, yes and no.
> >>
> >> fd's are a must have but I would be more interested to see an external
> >> checkpoint/restart and signal support first. why ? because it would be
> >> already usable for most computational programs in HPC, like this stupid
> >> one :
> >>
> >> 	https://www.ccs.uky.edu/~bmadhu/pi/pi1.c
> >>
> >> signals are required because it's how 'load' and/or 'system' managers
> >> interact with the jobs they spawn. external checkpoint/restart for the
> >> same reason.
> >
> > I'm sorry for being out of discussion for so long time.
> > I've just sent a patchset with external checkpoint/restart as it is
> > implemented in OpenVZ.
> > External checkpoint/restart also is very usefull if we will have
> > container's infrastructure in mainstream.
> > It won't be very hard to add support for signals in my patchset. I'll
> > wait for some time for comments and will add support for signals in next
> > version.
>
> OK.
>
> Then, we should be able to have a simple C/R framework (user and kernel) if
> we integrate your patchset or Oren's with Daniel's user tools :
>
> 	http://lxc.cvs.sourceforge.net/lxc/
>
> I was just starting to work on Oren's patchset when you sent yours :)

I will take a look on Daniel's user tools.

Thanks,
Andrey
