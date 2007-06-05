Return-Path: <linux-kernel-owner+w=401wt.eu-S933263AbXFEWt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbXFEWt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbXFEWtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:49:49 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbXFEWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:49:48 -0400
Message-ID: <4665E7CA.8030907@zytor.com>
Date: Tue, 05 Jun 2007 15:46:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Alan Cox <alan@redhat.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, drepper@redhat.com,
       roland@redhat.com, arjan@infradead.org, mingo@elte.hu,
       viro@zeniv.linux.org.uk, chrisw@redhat.com, sds@tycho.nsa.gov,
       sgrubb@redhat.com
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com>	 <20070603205653.GE25869@devserv.devel.redhat.com>	 <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil>	 <1181075666.3978.31.camel@localhost.localdomain>	 <Line.LNX.4.64.0706051658170.23379@d.namei>	 <20070605211616.GE23291@devserv.devel.redhat.com> <1181078927.3978.42.camel@localhost.localdomain>
In-Reply-To: <1181078927.3978.42.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> 
> While I understand, there are a few users who will have problems with
> this default are we really better to not provide this defense in depth
> for the majority of users and let those with problems turn it off rather
> than provide no defense by default?  I could even provide a different
> default for SELinux and non-SELinux if anyone saw value in that?  But if
> others think that off default is  best I'll send another patch shortly
> with the unsigned long fix and the default set to 0.  My hope is then
> that distros will figure out to turn this on.
> 

I hope not.  This breaks any hardware virtualizer.

So yes, we're better off not having this on, and require it to be
explicitly enabled by the end user.

Sorry.

	-hpa
