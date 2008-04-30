Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbYD3UhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbYD3UhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759465AbYD3UhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:37:01 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55689 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759224AbYD3UhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:37:00 -0400
Date: Wed, 30 Apr 2008 22:37:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: SL Baur <steve@xemacs.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andres Salomon <dilinger@queued.net>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Message-ID: <20080430203734.GA9837@uranus.ravnborg.org>
References: <20080429183531.GB19652@uranus.ravnborg.org> <20080429172402.14d7d40b@ephemeral> <ed10ee420804300345r5d4566d2uff5c3f49f1c15107@mail.gmail.com> <20080430080134.60346a12.randy.dunlap@oracle.com> <ed10ee420804301332n5fb72f3jb9bdea03aa313fad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed10ee420804301332n5fb72f3jb9bdea03aa313fad@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 01:32:52PM -0700, SL Baur wrote:
> On 4/30/08, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Wed, 30 Apr 2008 03:45:57 -0700 SL Baur wrote:
> 
> >  > Is there any reasonable way to embed the configuration file name in the kernel
> >  > image like BSD does it?  /proc/config.gz is a good way to retrieve way to
> >  > retrieve configuration information on a running system, not so good for pushing
> >  > kernels out to a network and keeping track of the config files on the build
> >  > machine.
> >
> >
> > I don't know how BSD does it, but CONFIG_IKCONFIG does embed the
> >  config image in the kernel.  It can be extracted with
> >  scripts/extract-ikconfig.
> 
> No, that's not what I meant.  Now that we have a means of specifying
> a configuration file by name, it would be nice if the file name could,
> for example, be appended to EXTRAVERSION.  That's all it would
> take to duplicate the behavior I misdescribed.
> 
> 
> Eg. `make K=HPxw4300.config ...' would have "-HPxw4300" appended
> to EXTRAVERSION.  Maybe this doesn't make sense any more, but it
> was once something I wanted very much.
You can just do:
echo "-HPxw4300" > localversion

Then it gets appended to the kernel version. While not automatic is
solves your need.

	Sam
