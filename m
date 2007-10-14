Return-Path: <linux-kernel-owner+w=401wt.eu-S1763955AbXJNVnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763955AbXJNVnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761015AbXJNVnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:43:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59401 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760901AbXJNVne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:43:34 -0400
Message-ID: <47128D76.5050407@garzik.org>
Date: Sun, 14 Oct 2007 17:43:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: {GIT pull] x86 bugfixes
References: <alpine.LFD.0.9999.0710142326451.22612@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710142326451.22612@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------010206050103090303070102"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010206050103090303070102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Thomas Gleixner wrote:
> Linus,
> 
> please pull from
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git
> 
> Thanks,
> 
> 	tglx
> --
> Dave Jones (1):
>       x86: fix missing include for vsyscall
> 
> Thomas Gleixner (3):
>       clockevents: introduce force broadcast notifier
>       x86: move local APIC timer init to the end of start_secondary()
>       x86: force timer broadcast on late AMD C1E detection
> 
>  arch/x86/kernel/alternative.c |    1 +
>  arch/x86/kernel/apic_64.c     |   26 ++++++++++++++++++++++++++
>  arch/x86/kernel/smpboot_64.c  |    7 ++-----
>  include/linux/clockchips.h    |    1 +
>  kernel/time/tick-broadcast.c  |   29 +++++++++++++++++++++++------
>  kernel/time/tick-common.c     |    1 +
>  6 files changed, 54 insertions(+), 11 deletions(-)

Unless the size is overlarge (currently 400k, on lkml), any chance I 
could talk you into appending the associated patch onto the end of 
future emails?

If it helps, I use the attached script when I send stuff upstream.

	Jeff




--------------010206050103090303070102
Content-Type: application/x-shellscript;
 name="mkmsg.sh"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="mkmsg.sh"

IyEvYmluL3NoCgojCiMgdXNhZ2U6IG1rbXNnIFticmFuY2hdIFtvdXRwdXQgdGV4dCBmaWxl
XQojCgpCUkFOQ0g9IiQxIgpURVhUX09VVD0iJDIiCgpQV0Q9YHB3ZGAKUkVQTz1gYmFzZW5h
bWUgJFBXRGAKCmVjaG8gIlBsZWFzZSBwdWxsIGZyb20gJyRCUkFOQ0gnIGJyYW5jaCBvZiIg
PiAkVEVYVF9PVVQKZWNobyAibWFzdGVyLmtlcm5lbC5vcmc6L3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9qZ2FyemlrLyRSRVBPLmdpdCAkQlJBTkNIIiBcCgk+PiAkVEVYVF9PVVQKZWNo
byAiIiA+PiAkVEVYVF9PVVQKZWNobyAidG8gcmVjZWl2ZSB0aGUgZm9sbG93aW5nIHVwZGF0
ZXM6IiA+PiAkVEVYVF9PVVQKZWNobyAiIiA+PiAkVEVYVF9PVVQKCmdpdCBkaWZmIC1NIC0t
c3RhdCAtLXN1bW1hcnkgbWFzdGVyLi4kQlJBTkNIID4+ICRURVhUX09VVAplY2hvICIiID4+
ICRURVhUX09VVApnaXQgbG9nIC0tbm8tbWVyZ2VzIG1hc3Rlci4uJEJSQU5DSCB8IGdpdCBz
aG9ydGxvZyA+PiAkVEVYVF9PVVQKZ2l0IGRpZmYgbWFzdGVyLi4kQlJBTkNIID4+ICRURVhU
X09VVAoK
--------------010206050103090303070102--
