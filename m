Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZGTWJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZGTWJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZGTWJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:09:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825AbZGTWJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:09:25 -0400
Date: Mon, 20 Jul 2009 15:08:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Krzysztof Oledzki <olel@ans.pl>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl>
Message-ID: <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Jul 2009, Krzysztof Oledzki wrote:
> 
> No problem. Please let me know what should I do to help tracking this issue.

Can you build two kernels: one with -fwrapv, and one with 
-fno-strict-overflow, and then verify that

 - they are otherwise identical (ie exact same source code, same compiler 
   etc)

 - verify that yes, the -fwrapv kernel works, the other does not. Just to 
   avoid the confusion that obviously exists with Debian/sid binutils 
   upgrades that _also_ happens result in nonbootable kernels.

 - upload the 'vmlinux' images somewhere (I'm not sure what the limits for 
   binary attachments are at the kernel bugzilla, but that would be the 
   logical place)

In fact, it would be nice to have a third "identical" kernel build, except 
with neither -fwrapv/-fno-strict-overflow.

			Linus
