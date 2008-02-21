Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbYBUIbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbYBUIbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYBUIbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:31:08 -0500
Received: from mail.lang.hm ([64.81.33.126]:60048 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYBUIbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:31:06 -0500
Date: Thu, 21 Feb 2008 08:30:06 +0000 (GMT)
From: david@lang.hm
X-X-Sender: olpc@xo-0C-FC-0F.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jesse Barnes <jesse.barnes@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
In-Reply-To: <alpine.LFD.1.00.0802201355590.7833@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802210819560.1777@xo-0C-FC-0F.localdomain>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com>
 <alpine.LFD.1.00.0802201355590.7833@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, Linus Torvalds wrote:

>> Well, it seems like we'll have to fix drivers in either case, and isn't a
>> kexec approach fundamentally more sound and simple, design-wise?  Rafael
>> pointed out some problems with properly setting wakeup states, but I think
>> that could be overcome...
>
> I don't personally mind kexec at all, but on the other hand, I don't care
> about suspend-to-disk in the first place. I do know that some people
> really don't want it, and I suspect that they have valid reasons. Ranging
> from memory use to simply just performance.

I've been watching for kexec hibernate for a little while now, and the 
last I saw was that acpi was incompatible with the kexec hibernate (but 
the suspend folks were still claiming that devices needed to be put in the 
'right mode' not just powered off. I've been waiting to see this resolved.

David Lang
