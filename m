Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbXE3TWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbXE3TWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbXE3TWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:22:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbXE3TWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:22:42 -0400
Date: Wed, 30 May 2007 15:22:14 -0400
From: Dave Jones <davej@redhat.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.1 on Fedora Core 6 breaks LVM/vgscan
Message-ID: <20070530192214.GC2794@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bill Davidsen <davidsen@tmr.com>,
	Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
	linux-kernel@vger.kernel.org
References: <200705210632.l4L6Wkt0004225@turbo.physics.adelaide.edu.au> <46585F02.6060806@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46585F02.6060806@tmr.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 12:23:30PM -0400, Bill Davidsen wrote:
 > Jonathan Woithe wrote:
 > > On 21 May 2007 I wrote:
 > > 
 > >> Attempting to compile a 2.6.21.1 kernel for use on a Fedora Core 6 box
 > >> results in a panic at boot because the root filesystem can't be found.
 > > 
 > > I have just compiled 2.6.22-rc2 with the configuration file given in my
 > > previous post and the resulting kernel successfully boots on the machine
 > > concerned.  Whatever broke LVM for this machine in between 2.6.18 and
 > > 2.6.21.1 has now been fixed.
 > > 
 > I haven't had any problem booting with any of the kernels, but when I 
 > try to build a kernel with a Fedora config from /boot, it builds fine 
 > but doesn't boot after install. I started by building a very basic 
 > kernel for testing, and then started adding features to get everything I 
 > need. But just using the latest FC6 config file gets me a kernel which 
 > fails in just the way you mention.

9 times out of 10 it's a busted initrd.
Pull it apart and check that the relevant storage modules & their dependancies
are present.

	Dave

-- 
http://www.codemonkey.org.uk
