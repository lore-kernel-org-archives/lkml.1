Return-Path: <linux-kernel-owner+w=401wt.eu-S933424AbXG0M5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424AbXG0M5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbXG0M5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:57:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57291 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbXG0M47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:56:59 -0400
Message-ID: <46A9EB97.4010406@garzik.org>
Date: Fri, 27 Jul 2007 08:56:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] AGP fixes for 2.6.23-rc1
References: <Pine.LNX.4.64.0707270206580.9484@skynet.skynet.ie>
In-Reply-To: <Pine.LNX.4.64.0707270206580.9484@skynet.skynet.ie>
Content-Type: multipart/mixed;
 boundary="------------030609030703020107040602"
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030609030703020107040602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dave Airlie wrote:
> 
> Hi Linus,
> 
> Please pull the 'agp-patches' branch from
> git://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git 
> agp-patches
> 
> It contains one very important fix from Nick for AGP hangs with the 
> nopage/pfn/flush stuff.. it also contains some minor docs changes and 
> one coverity fix.
> 
> Dave.
> 
>  Documentation/kernel-parameters.txt |    7 +++++++
>  drivers/char/agp/Kconfig            |    2 +-
>  drivers/char/agp/ati-agp.c          |    9 ++-------
>  drivers/char/agp/generic.c          |    2 --
>  drivers/char/agp/intel-agp.c        |   19 ++++++++++++-------
>  drivers/char/agp/sgi-agp.c          |    1 -
>  6 files changed, 22 insertions(+), 18 deletions(-)

It would really be nice to actually see the patches that go along with 
this.  Otherwise you are not giving outside reviewers any chance at all 
to evaluate these fixes.

Or were they posted on LKML, and I missed them?

Attached is the shell script I use to submit stuff to Linus, in case 
that helps any.

	Jeff




--------------030609030703020107040602
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
--------------030609030703020107040602--
