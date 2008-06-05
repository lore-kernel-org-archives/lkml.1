Return-Path: <linux-kernel-owner+w=401wt.eu-S1762385AbYFETkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762385AbYFETkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYFETjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:39:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33229 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYFETjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:39:52 -0400
Date: Thu, 5 Jun 2008 12:38:15 -0700
From: Greg KH <greg@kroah.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: 2.6.25.1, stray noise in dmesg
Message-ID: <20080605193815.GA32072@kroah.com>
References: <200805021126.15225.gene.heskett@gmail.com> <200805021910.45266.elendil@planet.nl> <200806052050.34537.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806052050.34537.elendil@planet.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 08:50:33PM +0200, Frans Pop wrote:
> On Friday 02 May 2008, Frans Pop wrote:
> > Gene Heskett wrote:
> > > I just rebooted to 2.6.25.1, and was momentarily panic'd by the
> > > messages going by early in the boot, but on putting 2&2 together,
> > > found they were just noise.
> > >
> > > From dmesg:
> > > [root@coyote ~]# dmesg|grep unable
> > > [    2.093502] hub 1-0:1.0: unable to enumerate USB device on port 2
> > > [    2.248475] hub 1-0:1.0: unable to enumerate USB device on port 5
> > > [    2.454444] hub 1-0:1.0: unable to enumerate USB device on port 6
> >
> > I'm seeing these too (hub 5-0):
> > hub 5-0:1.0: USB hub found
> > hub 5-0:1.0: unable to enumerate USB device on port 5
> > hub 5-0:1.0: unable to enumerate USB device on port 7
> 
> I'm going to bring this up one last time.
> 
> Google currently already shows 1060 hits for this new error:
> http://www.google.com/search?q=%22unable+to+enumerate+USB+device%22&ie=UTF-8&oe=UTF-8
> 
> This one is particularly interesting as it shows quite a few systems
> are affected: https://bugzilla.redhat.com/show_bug.cgi?id=446845
> 
> Given its apparent prevalence I'm still wondering whether this is
> really broken hardware in all cases or that there could be an error
> in detection in some cases.
> 
> Note that in my case this is not with an external hub or anything, but just
> the internal USB ports of the system.
> 
> One thing with this message is that because of its "error" status, it
> also shows when the system is booted with the "quiet" option. Could it be
> an option to apply the following patch so that at least that is avoided?

I agree, I'll change the message to be this, thanks for the patch.

greg k-h
