Return-Path: <linux-kernel-owner+w=401wt.eu-S1751193AbXCCH6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193AbXCCH6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 02:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXCCH6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 02:58:23 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:48269 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbXCCH6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 02:58:23 -0500
Message-ID: <45E92A9E.6030108@vmware.com>
Date: Fri, 02 Mar 2007 23:58:22 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] Vmi fix highpte
References: <200703020254.l222smBB009668@zach-dev.vmware.com> <45E79529.9000305@goop.org> <45E79C72.4000806@goop.org> <45E7C4DD.1040403@vmware.com> <45E7C80E.1020107@goop.org> <45E7F405.6020507@vmware.com> <45E8571F.1050509@goop.org> <45E920F6.7060806@vmware.com> <45E9273A.4040300@goop.org>
In-Reply-To: <45E9273A.4040300@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>
> I can deal with the change going into -git, but it does seem awkward
> knowing that it is the wrong change and it will be replaced by something
> else almost immediately.
>   

Well, it is not quite wrong - it is appropriate for -git.  That it will 
be replaced soon is a minor thing, as long as we can work together to 
make sure your patches are unaffected.

> My main concern is that the Xen patch queue is complex enough as-is, and
> I've been trying hard to remove dependencies on other uncommitted
> patches.   It's doubly complex because I'm not really sure if I'm
> targeting Andrew or Andi's tree as a base, though at the moment -git
> seems to work either way.
>
>     J
>   

Believe me, I understand the complexities of dealing with -mm, -git, and 
-i386 trees.  It's not just doubly complex, its triply so.  I believe 
the best approach is to make it easiest on the maintainers.  So the 
patch stream I am uploading through -mm, -i386, to -git does not 
conflict with the Xen patch queue as long as we make sure the next 
bundle to those same trees applies clean.  Again, I broke the Xen patch 
queue in -mm, and for that I am sorry.  I will help you re-integrate 
against the VMI patches I sent out, as I broke your code, I will help 
fix it.  And we both have a tree to work off from, which makes it rather 
easy to work together ;)

Cheers,

Zach

----

Sutra I.2 - interruptah chittavritti nirodhah
