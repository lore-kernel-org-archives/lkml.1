Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbYICWyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbYICWyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYICWyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:54:43 -0400
Received: from tundra.namei.org ([65.99.196.166]:40384 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYICWym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:54:42 -0400
Date: Thu, 4 Sep 2008 08:53:50 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [GIT] Fix SELinux memory leak regression for 2.6.27
In-Reply-To: <alpine.LFD.1.10.0809030843310.3259@nehalem.linux-foundation.org>
Message-ID: <alpine.LRH.1.10.0809040853060.24576@tundra.namei.org>
References: <alpine.LRH.1.10.0809031015260.17746@tundra.namei.org> <alpine.LRH.1.10.0809032238080.21379@tundra.namei.org> <alpine.LFD.1.10.0809030843310.3259@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Linus Torvalds wrote:

> 
> 
> On Wed, 3 Sep 2008, James Morris wrote:
> > On Wed, 3 Sep 2008, James Morris wrote:
> > 
> > > This is causing recent Fedora systems to die a slow and painful death.  
> > > Please pull.
> > 
> > Further review has raised an issue with this patch, an updated version 
> > should be available soon.
> 
> Ahh, that also explains why the branch isn't there any more. Thanks,

A more correct version of the patch is now up, please pull:

The following changes since commit ec0c15afb41fd9ad45b53468b60db50170e22346:
  Linus Torvalds (1):
        Split up PIT part of TSC calibration from native_calibrate_tsc

are available in the git repository at:

  
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Eric Paris (1):
      SELinux: memory leak in security_context_to_sid_core

 security/selinux/ss/services.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)





-- 
James Morris
<jmorris@namei.org>
