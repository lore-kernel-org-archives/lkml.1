Return-Path: <linux-kernel-owner+w=401wt.eu-S1422903AbXBGS5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422903AbXBGS5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422866AbXBGS5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:57:03 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1570 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422793AbXBGS46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:56:58 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <helge.hafting@aitel.hist.no>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Ban module license tag string termination trick
Date: Wed, 7 Feb 2007 10:56:12 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEAGBHAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <45C9C3A3.1020201@aitel.hist.no>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 07 Feb 2007 10:56:33 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 07 Feb 2007 10:56:35 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Indeed, but using the provided key is not circumventing. Loading a
> non-GPL module that uses GPL symbols anyway is prevented, so
> forcibly loading such a module "the rootkit way" by patching /dev/mem
> is a circumvention. Catch one of the script kiddies inside the US, and 
> you can
> theoretically nail him with the DMCA these days.

The greater has to include the lesser. If you have the authority to remove or modify a copyright enforcement scheme, you cannot be circumventing it.

In any event, if your argument were correct, the Linux kernel would not be distributable. The license enforcement scheme in the kernel makes it unlawful to modify the modules in a particular way, and they are both distributed under the GPL. This would be a "further restriction" since the restriction is not found in the GPL itself.

> Changing the source (allowed by the GPL) is not circumvention.

Then you can change the module source to include a null in the license tag.

> Just as using your door key does not circumvent the door lock even
> though you open it.

And neither is breaking down your own door. If you have the right to remove the door, you have the right to break it down. The greater includes the lesser.

> You might call this weak protection indeed,
> seeing how easy it is.  Still, it means that a vendor of closed-source
> modules that use GPL symbols now must distribute a kernel of
> their own instead of just a module. Such rouge modules will no longer
> load.  Alternatively, they can set the licence string to GPL but
> then they must live up to it and provide source.

Sounds like a further restriction to me. This is a restriction on how the modules can be modified, it's not found in the GPL, and it was imposed by people who modified the kernel. This is exactly what the GPL was designed to force people to remove before they could distribute a work.

> The "copyright protection" stuff works the same way, I think.  You can't
> deny distributing under the GPL just because someone could alter the
> source so it breaks other law.  The GPL allow circumvention, it 
> is only the
> DMCA that doesn't.  Just like that holocaust law - the GPL allows
> such denial too.

Right, but you can't put something into your source such that someone removing it or modifying it is breaking the law. If there was a law that said a file could not be modified if someone put the words "DO NOT MODIFY" in it, then you could *not* put such words in a GPL'd work. If you did, such a work would not be distributable because the law imposes a further restriction.

The DMCA is no different. It's a law that says if you put a copyright enforcement scheme in a work, then someone can't circumvent it. Since there are no anti-circumvention rules in the GPL itself, it's a further restriction.

Simply put, if you assume this is a license enforcement scheme, then the Linux kernel together with some modules contains a further restriction that prohibits you from modifying the modules in ways allowed by the GPL. This is precisely what the GPL prohibits.

> " For example, if a patent license would not permit 
> royalty-free redistribution of the Program by all those who 
> receive copies directly or indirectly through you, then the only 
> way you could satisfy both it and this License would be to 
> refrain entirely from distribution of the Program. "

> It is still royalty-free.

You are missing the point of the example. This is an example of what happens when some kind of legal process not found in the GPL operates to restrict the rights guaranteed by the GPL.

> I am not so sure that a copyright protection scheme violates even
> the spirit of the GPL, as long as the keys are _always_ provided?
> Because then the option of using they keys are always there,
> so you can indeed make all the changes you want - and redistribute.
> Which is also a reason why this scheme never will get
> sophisticated - after all, it is always both legal and possible to
> patch it out of the sources.

I cannot see any rational way you can have the right to modify all the involved code, the right to remove the scheme, and yet you can be "circumventing" it.

> Note that this particular scheme doesn't even try to prevent copying.

That's simply not true. It makes some proprietary modules unusable on mainstream kernels, thus decreasing the value of them if they're distributed. This is exactly what many anti-copying schemes do.

How is this scheme (which makes mainstream kernels unable to work with modules that are not GPL-licensed) different from the DVD scheme (that makes unlicensed players unable to play mainstream DVDs)? Engineered incompatability restricts the distribution value of the items made incompatible.

> It tries to protect the GPL by making it harder to erode it by
> getting into a situation where 90% of the drivers necessary to
> run a linux kernel are proprietary.

If you choose the GPL, you lose the right to "make it harder" for people to distribute and modify code. The GPL sets the terms and is carefully constructed so that nobody can later change them.

> It does so by ensuring that the
> proprietary vendors access a limited API, unless they take
> a lot of cumbersome extra steps like maintaining their own
> "protection-free" kernel.  Which they certainly can do under
> the GPL, but most prefer being compatible with distro kernels
> and stock kernels.

This is precisely the type of thing the GPL was designed to prohibit. You are not supposed to be able to abuse copyright to retain control over a GPL'd work.

DS


