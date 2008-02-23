Return-Path: <linux-kernel-owner+w=401wt.eu-S1765054AbYBWLYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765054AbYBWLYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYBWLY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:24:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53519 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYBWLY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:24:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 23 Feb 2008 12:23:30 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/2] firewire: endinaness warnings (was Re: sparse - make
 __CHECK_ENDIAN__ default enabled?)
To: linux1394-devel@lists.sourceforge.net
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Kristian Hoegsberg <krh@bitplanet.net>,
       Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <1203545913.25307.47.camel@brick>
Message-ID: <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de>
References: <20080220220326.GA22328@uranus.ravnborg.org>
 <1203545913.25307.47.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Feb, Harvey Harrison wrote on LKML:
> On Wed, 2008-02-20 at 23:03 +0100, Sam Ravnborg wrote:
>> Hi Harvey.
>> 
>> Can I ask you to look into the worst offenders so we
>> can make -D__CHECK_ENDIAN__ enabled per default
>> in the kernel.
>> Or maybe we should do it anyway?
> 
> Well, I've got the worst of fs and drivers/ata done so far, still
> weeping over the 5500 warnings in drivers. (X86_32 allyesconfig).
> People ignore the existing warnings anyway, why not toss a few more
> on the pile?
> 
> I'll look them over tonight and see how bad it would be.

I looked into drivers/firewire and drivers/ieee1394.  As expected, there
are quite a lot endianess related warnings in the latter because this is
code from way before sparse was regularly used.

There are also a few warnings in the former, even though sparse checks
were run before submission of the whole drivers/firewire stack.  I will
follow up with two patches:
	1/2 firewire: endianess fix
	2/2 firewire: endianess annotations
Whether the "fix" is really a fix remains to be seen; I don't have a big
endian Linux box myself.
-- 
Stefan Richter
-=====-==--- --=- =-===
http://arcgraph.de/sr/

