Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbXA3WFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbXA3WFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXA3WFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:05:50 -0500
Received: from main.gmane.org ([80.91.229.2]:43991 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbXA3WFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:05:49 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jeroen Roodhart <jeroen@tuxwielder.nl>
Subject: [Maybe FIXed] Re: Forcedeth issues, loss of connectivity.  ASUS M2N32-SLI-D w/ AMD64
Date: Tue, 30 Jan 2007 22:05:20 +0000 (UTC)
Message-ID: <loom.20070130T225608-526@post.gmane.org>
References: <45B91769.8060403@blue-labs.org> <loom.20070128T130718-569@post.gmane.org> <20070130183208.GE11814@melchior.yamamaya.is-a-geek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 80.100.34.80 (Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.1) Gecko/20061208 Firefox/2.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich <ranma+kernel <at> tdiedrich.de> writes:
> 
> I've seen some issues with forcedeth too, but only with 2.6.20-rc5
> and -rc6 as far as I can say.  The box stopped receiving packets, but a
> "ifconfig eth0 promisc" 'fixed' it.

Sorry forgot to mention: I'm running FC6 with the 2.6.19-1.2895.fc6 x86_64 
kernel.
RPM says that it is based on:

* Wed Jan 10 2007 Dave Jones <davej@redhat.com>
- 2.6.19.2

I tried to upgrade to the forcedeth driver that is supplied with 2.6.20-rc4-mm1
but that gave results that look like Tobias' description.

Then I downloaded the Nvidia provided version from:

http://download.nvidia.com/XFree86/nforce/1.21/NFORCE-Linux-x86-1.21.zip

The forcedeth driver from this file announces itself as:

Version 0.60-Driver Package V1.21.

After some minor patching I got this to work with the FC6 2.6.19-1.2895 kernel
and I just played 2 movies through the network whilst downloading a large number
of files onto the server. So far no network crashes. Maybe something for David
to try out as well?

Thanks for the information,

With kind regards,

Jeroen




