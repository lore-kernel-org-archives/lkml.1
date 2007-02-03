Return-Path: <linux-kernel-owner+w=401wt.eu-S1751039AbXBCSci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039AbXBCSci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 13:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXBCSci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 13:32:38 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2793 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXBCSch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 13:32:37 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Ban module license tag string termination trick
Date: Sat, 3 Feb 2007 10:31:54 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEJIBFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <45C3164C.1050805@aitel.hist.no>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 03 Feb 2007 10:32:09 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 03 Feb 2007 10:32:10 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The way I see this:
> There is a copyright enforcement scheme.  (A simple test for
> the word GPL.) Trivial, but still an enforcement scheme.

If this were true, then the Linux kernel with it could not be distributed.

If it were a legal mechanism to prevent people from modifying modules, then it's a further restriction. Whoever distributes a Linux kernel with a copyright enforcement scheme (assuming it includes at least one module) is violating section 6 of the GPL.

Adding a copyright enforcement scheme to the kernel, and then distributing it with modules that cannot be modified in some ways because of that scheme, is imposing a "further restriction". (Since the GPL does not contain the restriction.)
 
> You are of course allowed to remove the test completely,
> as the GPL lets you change the kernel source in any way you wish.

It also lets you change the modules in any way you wish. I can't see how you can have it both ways. How is removing an enforcement scheme not circumventing it?
 
> But you are still not allowed to circumvent the scheme as long as
> it is in place - in those parts of the world were circumventing is
> illegal.

If that's true, then the Linux kernel cannot be distributed in those parts of the world where circumventing is illegal. The GPL does not prohibit circumventing anything, so the DMCA (as invoked by those who added copyright enforcement schemes to the kernel) would be them imposing a further restriction on our right to modify the modules included with the kernel.

> So a vendor using the \0 trick is on very shaky ground. 
> He has another option - to patch out the test.  But he
> don't want that, for then he have to distribute a kernel,
> not only a module.

The GPL does not permit you to (ab)use the law to prevent people from modifying GPL'd works. If a law prevents people from modifying GPL'd works, then those works cannot be distributed where that law applies.

You can certainly argue that this doesn't make sense if the law is not deliberately invoked. For example, some countries have a law against denying the Holocaust. I don't think you can rationally argue that no works are disrtibutable under the GPL there because someone can't legally modify those works to deny the Holocaust.

But the assumption that the GPL linkage code is a copyright enforcement scheme would mean that the Linux kernel would have been deliberately modified so as to invoke a law that prevents people from modifying GPL'd works -- including the modules included with the kernel itself. If that doesn't make the kernel undistributable, the GPL clause 7 doesn't mean anything.

" For example, if a patent license would not permit royalty-free redistribution of the Program by all those who receive copies directly or indirectly through you, then the only way you could satisfy both it and this License would be to refrain entirely from distribution of the Program. "

It seems to me that another example would be if the DMCA does not permit modification of portions of the Program, then you cannot distribute the program.

This is the way the GPL's "self destruct" mechanism is supposed to work. For example, if someone claims there's a patent that prevents some piece of the Linux kernel from being used freely, the GPL is designed to force Linux developers and distributors to hack that piece out of the kernel so that the program can remain free to distribute and modify. It actually *fixes* legal problems by prohibiting distribution until the distributors can figure out how to get people's GPL rights back.

The way out of the GPL problem is to make clear that it is *not* a copyright enforcement scheme, it's simply a notification scheme. Claims and actions in another direction threaten the distributability of the Linux kernel, and frankly violate the intent, spirit, and precise language of the GPL.

DS


