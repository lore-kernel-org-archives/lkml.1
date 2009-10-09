Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbZJIRP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbZJIRP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbZJIRP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:15:28 -0400
Received: from kroah.org ([198.145.64.141]:38928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761180AbZJIRP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:15:27 -0400
Date: Fri, 9 Oct 2009 10:11:37 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier <fredlwm@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31: no login prompt
Message-ID: <20091009171137.GA4131@kroah.com>
References: <alpine.LNX.2.01.0909191941270.24796@pervalidus>
 <20091009160951.GA2766@kroah.com>
 <alpine.LNX.2.01.0910091349490.5219@dyndns.pervalidus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.01.0910091349490.5219@dyndns.pervalidus.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 01:53:14PM -0300, Frédéric L. W. Meunier wrote:
> On Fri, 9 Oct 2009, Greg KH wrote:
> 
> > On Sat, Sep 19, 2009 at 07:43:04PM -0300, Frédéric L. W. Meunier wrote:
> >> While booting 2.6.31, I don't get a login prompt after runlevel
> >> 3:
> >>
> >> Sep 19 18:31:25 pervalidus init: Id "c1" respawning too fast: disabled for 5 minutes
> >> Sep 19 18:31:25 pervalidus init: Id "c3" respawning too fast: disabled for 5 minutes
> >> Sep 19 18:31:25 pervalidus init: Id "c2" respawning too fast: disabled for 5 minutes
> >>
> >> It works fine with 2.6.30.5.
> >>
> >> What can be causing it ?
> >
> > This should be fixed in 2.6.31.3, can you verify this?
> 
> Greg, this was caused by using vc/* entries in /etc/inittab and 
> old devfs rules in udev.
> 
> I don't think the fix would make any difference for it. Would it 
> ?

Ah, if you found the problem, great, I was worried it was a tty layer
issue.

thanks,

greg k-h
