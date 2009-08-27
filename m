Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbZH0MT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbZH0MT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZH0MT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:19:57 -0400
Received: from flpi195.sbcis.sbc.com ([207.115.20.197]:47709 "EHLO
	flpi195.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZH0MT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:19:56 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2009 08:19:56 EDT
X-ORBL: [99.72.37.103]
DomainKey-Signature: a=rsa-sha1; s=sbc01; d=ameritech.net; c=nofws; q=dns;
	h=date:from:x-x-sender:reply-to:to:subject:message-id:
	user-agent:return-receipt-to:mime-version:content-type;
	b=owLDHKfZMsWqvPlomgbfG32bn6Y7XvOSSio5Voix/MG/co011dB2qGwVFcNdSuhge
	8htc/xC3rWcoNVRtl+k8A==
Date: Thu, 27 Aug 2009 08:12:31 -0400 (EDT)
From: "F. Heitkamp" <heitkamp@ameritech.net>
X-X-Sender: heitkamp@pc1lin.fred.org
Reply-To: heitkamp@ameritech.net
To: linux-kernel@vger.kernel.org
Subject: popen2 popen call
Message-ID: <alpine.DEB.1.10.0908270803540.3447@pc1lin.fred.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am using vanilla kernel 2.6.31-rc7, glibc 2.10.x on a Core 2 Duo system.

When the popen call is made in sshd/session.c I get a error from strerror 
of "Function not Implemented".  I googled a bit and found that there is 
sometimes an problem between the way the kernel and glibc are compiled 
that causes glibc not to find the popen2 call in the kernel.  The fix 
seemed to imply I need a certain processor choice when compiling the 
kernel.

Strangely, simple popen test programs seem to work OK.

Can anyone shed some light on this for me?  I would like to get this to 
work, so my X11 forwarding works in ssh.

BTW, kernels before 2.6.27 don't seem to cause the problem to manifest 
itself.

Thanks!

Fred

