Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYKTIFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYKTIFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbYKTIEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:04:54 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42348 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbYKTIEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:04:53 -0500
Subject: Re: Current state of Network Namespaces (NETNS, CLONE_NEWNET)?
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Pavel Emelyanov <xemul@openvz.org>, David Miller <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       adobriyan@gmail.com, Patrick McHardy <kaber@trash.net>, den@openvz.org,
       ltp-list <ltp-list@lists.sf.net>
In-Reply-To: <492517BC.3050205@fr.ibm.com>
References: <492489D1.5080502@gmail.com>  <492517BC.3050205@fr.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Thu, 20 Nov 2008 13:34:17 +0530
Message-Id: <1227168257.4978.6.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-11-20 at 08:54 +0100, Daniel Lezcano wrote:
> Michael Kerrisk wrote:
> > Sorry for the shotgun mail, but in the end,  it's
> > not clear who can best answer my question(s).
> > 
> > I'm currently trying to add documentation of all of
> > the undocumented CLONE_* flags.  One of these is
> > CLONE_NEWNET, and I could use (quite a lot of) help.  
> > 
> > My questions:
> > 
> > What is the current state of the network namespace 
> > implementation?  Is it complete?  
> 
> It is not complete but mostly usable for ipv4 and ipv6.
> 
> There is a network namespace status I filled at:
> 
> http://lxc.sourceforge.net/network/status.php
> 
> It should be up-to-date.
> 
> > What objects are considered part of the network 
> > namespace, and therefore distinct for a new network 
> > namespace?
> 
> The network namespace brings isolation from the layer-2 to upper layers.
> 
> > Is there any documentation for network namespaces 
> > already?
> 
> http://lxc.sourceforge.net/network.php
> http://lxc.sourceforge.net/doc/sigops/appcr.pdf
> 
> > Are there any test programs for network namespaces?
> 
> http://sourceforge.net/projects/lxc/

And also at:

http://ltp.cvs.sourceforge.net/viewvc/ltp/ltp/testcases/kernel/containers/

Regards--
Subrata

> 
> follow the README page. It is still in development but mainly usable  - 
> any feedbacks are welcome :)
> 

