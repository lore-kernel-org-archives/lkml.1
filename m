Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbZANUJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbZANUJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbZANUJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:09:04 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:38223 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZANUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:09:01 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "SE-Linux" <selinux@tycho.nsa.gov>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
Date: Wed, 14 Jan 2009 15:08:58 -0500
User-Agent: KMail/1.9.10
Cc: "Justin P. Mattock" <justinmattock@gmail.com>
References: <496D759A.7010401@gmail.com> <496E21B3.3070206@gmail.com> <200901141504.30674.paul.moore@hp.com>
In-Reply-To: <200901141504.30674.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141508.58174.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009 3:04:30 pm Paul Moore wrote:
> On Wednesday 14 January 2009 12:32:35 pm Justin P. Mattock wrote:

...

> > >> The next is a macbookpro ati chipset the kernel is 2.6.29-rc1
> > >> the o.s. is ubuntu jaunty, the netlabel_tools is the same as
> > >> above. the only results I see out of this is the avc's it's
> > >> generating (the allow rules above are from the macbook);
> > >> some reason the dell doesn't generate any avc's,
> > >> which makes me wonder is this a module issue.
> > >
> > > Huh.  Just so I'm clear on this ... on the macbook you see avc
> > > denials that correspond to the allow rules you posted above, but
> > > on the dell you don't see the same avc denials?  Are you running
> > > the same SELinux policy on both systems (version numbers)?  What
> > > is the output of the following command on both systems?
> > >
> > >  # cat /selinux/policy_capabilities/network_peer_controls
> >
> > for both systems I'm running the refpolicy(svn) from tresys.
> > the new ubac options, and newrole mechanism etc..
> > doing cat /selinux/policy_capabilities_netowork_peer_controls says
> > "1" should be for both.
>
> Ahhhh!  How did that happen?!  (see my response to your other email)

Sorry, just realized your other email was private.  In case anyone else 
is following this thread, the SELinux policy for network_peer_controls 
policy capability is still a work in progress and is disabled by 
default because there are still a few issues remaining.  Disabling the 
network_peer_controls (the default configuration) fixed the problem.

-- 
paul moore
linux @ hp
