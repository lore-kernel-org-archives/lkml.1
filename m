Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbYCAFYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYCAFYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 00:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYCAFXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 00:23:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbYCAFXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 00:23:51 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/2] firewire: endinaness warnings (was Re: sparse - make __CHECK_ENDIAN__ default enabled?)
Date: Sat, 1 Mar 2008 00:23:24 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux1394-devel@lists.sourceforge.net,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Kristian Hoegsberg <krh@bitplanet.net>
References: <20080220220326.GA22328@uranus.ravnborg.org> <1203545913.25307.47.camel@brick> <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de>
In-Reply-To: <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803010023.25086.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008 06:23:30 am Stefan Richter wrote:
> On 20 Feb, Harvey Harrison wrote on LKML:
> > On Wed, 2008-02-20 at 23:03 +0100, Sam Ravnborg wrote:
> >> Hi Harvey.
> >>
> >> Can I ask you to look into the worst offenders so we
> >> can make -D__CHECK_ENDIAN__ enabled per default
> >> in the kernel.
> >> Or maybe we should do it anyway?
> >
> > Well, I've got the worst of fs and drivers/ata done so far, still
> > weeping over the 5500 warnings in drivers. (X86_32 allyesconfig).
> > People ignore the existing warnings anyway, why not toss a few more
> > on the pile?
> >
> > I'll look them over tonight and see how bad it would be.
>
> I looked into drivers/firewire and drivers/ieee1394.  As expected, there
> are quite a lot endianess related warnings in the latter because this is
> code from way before sparse was regularly used.
>
> There are also a few warnings in the former, even though sparse checks
> were run before submission of the whole drivers/firewire stack.  I will
> follow up with two patches:
> 	1/2 firewire: endianess fix
> 	2/2 firewire: endianess annotations
> Whether the "fix" is really a fix remains to be seen; I don't have a big
> endian Linux box myself.

Doesn't hurt anything on my end, spb2 devices work, they survive bus resets 
and so on. The funky uninorth controller definitely doesn't work, but it 
didn't before the patch either, and the fix is being chased in another patch 
series.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com
