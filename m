Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbZEIPM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbZEIPM6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZEIPMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:12:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZEIPMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:12:49 -0400
Date: Sat, 9 May 2009 08:08:53 -0700
From: Greg KH <gregkh@suse.de>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090509150853.GA32394@suse.de>
References: <20090509143742.GA27663@kroah.com> <b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 05:10:24PM +0200, Fabio Comolli wrote:
> Hi.
> 
> On Sat, May 9, 2009 at 4:37 PM, Greg KH <greg@kroah.com> wrote:
> > Here's the latest version of the devtmpfs patch, broken up into 13
> > different patches to make it easier to review and merge properly.
> >
> > This series does the following:
> >  - creates a new callback within the driver core to allow drivers and
> >    subsystems to provide a name for their subsystem to properly reflect
> >    what userspace should use for their device nodes.  This allows for
> >    things like the sound/ and input/ subdirectories to be properly told
> >    to userspace.  Note these names and subdirectories are the ones that
> >    have been used for years, and are standardized across all
> >    distributions and synced up with the LANANA naming scheme which is
> >    specified by LSB.  We aren't creating anything new here.
> >  - fills in the callbacks by the various subsystems that need to define
> >    it, including the misc device layer.  This is the majority of the
> >    patches in the series.
> >  - adds the devtmpfs core code.  Description of what this is, why it is
> >    needed, and how it works is within this patch.
> >
> > All of these patches have been tested for a number of weeks now in
> > SuSE's kernel trees and have proved to increase boot time a measurable
> > ammount (a few seconds at the very least)
> 
> Well, guess you meant the opposite ;-)

Heh, yes, sorry about that.  It makes booting faster :)

thanks,

greg k-h
