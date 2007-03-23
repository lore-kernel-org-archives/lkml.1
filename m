Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbXCWFmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbXCWFmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 01:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXCWFmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 01:42:36 -0400
Received: from mail.kroah.org ([69.55.234.183]:49229 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbXCWFmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 01:42:35 -0400
Date: Thu, 22 Mar 2007 21:48:23 -0700
From: Greg KH <greg@kroah.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sysfs q [was: sysfs ugly timer interface]
Message-ID: <20070323044823.GA8881@kroah.com>
References: <200703161230.03712.maximlevitsky@gmail.com> <200703161919.44458.lenb@kernel.org> <200703180100.01889.maximlevitsky@gmail.com> <20070320115403.GA3983@ucw.cz> <20070322152842.GA6054@kroah.com> <Pine.LNX.4.61.0703230221350.9555@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703230221350.9555@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 02:24:46AM +0100, Jan Engelhardt wrote:
> 
> On Mar 22 2007 08:28, Greg KH wrote:
> >> 
> >> > root@MAIN:/home/maxim# cat /sys/devices/system/clockevents/clockevents0/registered
> >> > lapic                F:0007 M:3(periodic) C: 1
> >> > hpet                 F:0003 M:1(shutdown) C: 0
> >> > lapic                F:0007 M:3(periodic) C: 0
> >> > root@MAIN:/home/maxim#   
> >> 
> >> Now... this file needs to die, before 2.6.21 is released. It tries to
> >> bring /proc-like parsing nightmare to sysfs. Kill it before it becomes
> >> part of stable ABI!
> >
> >Eeek!
> 
> Question regarding sysfs files: How would you do something like
> /proc/net/nf_conntrack with sysfs? Have directories named like 0000, 
> 0001, 0002, ..?

I don't know, I've never said that _all_ proc files can move to sysfs.
For some things, like possibly the netfilter stuff, proc files make more
sense.

Were you thinking of moving this file to sysfs?  What does the
information in it represent?

thanks,

greg k-h
