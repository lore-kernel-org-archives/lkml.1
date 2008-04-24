Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYDXSN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYDXSN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYDXSNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:13:19 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58192 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968AbYDXSNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:13:19 -0400
Date: Thu, 24 Apr 2008 14:13:13 -0400 (EDT)
From: Jeff Arnold <jbarnold@MIT.EDU>
To: Christian Hesse <mail@earthworm.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: A system for rebootless kernel security updates
In-Reply-To: <200804241543.06874.mail@earthworm.de>
Message-ID: <alpine.DEB.1.00.0804241306260.21001@vinegar-pot.mit.edu>
References: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu> <200804241543.06874.mail@earthworm.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just wanted to test on my Gentoo system with kernel 2.6.25. The 
> tarball creation works, but applying the change brings an error to 
> syslog

Sorry.  (In 2.6.25, init_mm is marked as an unused symbol, and so whether 
it is exported depends on whether CONFIG_UNUSED_SYMBOLS is enabled).

I've committed a change which should fix this problem.  You can get get 
the new version (0.8.1) from http://web.mit.edu/ksplice/dist/ or from Git. 
(I haven't yet made the new version the default, so you won't receive it 
from the main Ksplice page).

Jeff Arnold
jbarnold@mit.edu

On Thu, 24 Apr 2008, Christian Hesse wrote:

> On Wednesday 23 April 2008, Jeff Arnold wrote:
>> Hello,
>>
>> I've put together an automatic system for applying kernel security patches
>> to the Linux kernel without rebooting it, and I wanted to share this
>> system with the community in case others find it useful or interesting.
>
> This sounds really interesting. I just wanted to test on my Gentoo system with
> kernel 2.6.25. The tarball creation works, but applying the change brings an
> error to syslog:
>
> ksplice_242e9pfc_helper: Unknown symbol init_mm
>
> Any chance to get a fix for that?
> --
> Regards,
> Chris
>
