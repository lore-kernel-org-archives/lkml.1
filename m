Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYFDIwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYFDIwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYFDIwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:52:25 -0400
Received: from main.gmane.org ([80.91.229.2]:58016 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbYFDIwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:52:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: Who can backport the AHCI driver to older kernels
Date: Wed, 4 Jun 2008 08:52:17 +0000 (UTC)
Message-ID: <loom.20080604T084211-739@post.gmane.org>
References: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com> <alpine.LNX.1.10.0806031332410.4055@fbirervta.pbzchgretzou.qr> <200806040647.03185.Rainer.Koenig@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 192.54.193.59 (Mozilla/5.0 (Windows; U; Windows NT 5.0; fr; rv:1.9) Gecko/2008051206 Firefox/3.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rainer Koenig <Rainer.Koenig <at> fujitsu-siemens.com> writes:

> 
> Hi Jan,
> 
> Am Dienstag, 3. Juni 2008 13:37 schrieb Jan Engelhardt:
> > >The target market for those boards is using old fashioned
> > > distributions like CentOS, Debian, Fedora 8 openSUSE 10 and so on.
> >
> > Wait a minute, that seems like an impossible dependency.
> > These boards cannot be targeted for these distro versions,
> > because the manufacturer knows (hopefully) that the shipped
> > kernel versions do not have the driver with the required
> > new code.
> 
> Yes, of course the manufacturer knows. But the customer wants to get the 
> benefits from the new chipset technologie (e.g. support for quad core 
> processors). The problem that we are facing is that we can't tell the 
> customer "You cannot install actual Linux distributions", especially 
> not when your customer is a firm that offers hosting services based on 
> that platform. 

Fedora 8 may not work but Fedora 9 will work out of the box.
You've stated RHEL works. That means Centos will work too eventually if it's not
working already.

So on the RHEL/Centos/Fedora side you're already ok. Previous versions won't
work, but the Linux support model is to upgrade systems not maintain old ones on
life support indefinitely. The only way to shorten the hardware release to new
distro support time is to get drivers in kernel.org earlier.


