Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbXCaXBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbXCaXBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 19:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXCaXBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 19:01:00 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:42714 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbXCaXA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 19:00:59 -0400
Date: Sun, 01 Apr 2007 00:58:30 +0200
Message-Id: <1712880100@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@addtoit.com
Subject: [RFC] UML kernel & rootfs bundle with every kernel release ?
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

i`m not very much into UML for the last months, but while playing around with dm-loop i just got one idea i`d like to share.

Whenever you want to test some new kernel (feature), you may put you main system at risk, exactly know what you`re doing - or - use UserModeLinux.

The "problem" with UML is:

- you needs to compile an UML kernel first.
- you needs some "basic" knowlege about UML to get things running.
- you need to create an appropriate filesystem image for UML - or find some for download
- you need to copy appropriate kernel modules inside
- you need to put kernel sources inside, have compiler......
- you may need appropriate modle-init-tools,initrd, kernel specific tools (updated dmsetup, updated....whatever)

in short: 
it`s quite some work to be done to have your uml 2.6.21 with root-fs up and running and working cleanly.
whenever i search the net for some appropriate UML fs image, those i find are very often old and outdated...

is there a project/website which is offering such ready to run "UML kernel+rootfs release bundles" for download (i.e. new kernel,generic  root-fs, modules inside, sources inside, compiler inside - in sync with the latest stable vanilla) , or , would it make sense to establish such project ?
i.e. besides releasing the kernel, also releasing sort of a kernel "runtime kit" and/or "devkit" ?

i think this could be very helpful for linux-kernel, because it could be tested by more people more quickly, more easily and thus, more often.
just download, do few steps for setup, start up that virtual machine and there you go testing, hacking into the sources, do all that things you never would do on your main system,  whatever....

it would probably also add benefit to UML itself.

does this sound dumb? i don`t know, so please comment.

regards
roland

PS:
ok, this would be some 500M to 1G download, but there`s lot`s of bandwidth today - and P2P/Bittorrent.....
_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

