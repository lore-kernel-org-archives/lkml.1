Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbYLKX1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbYLKX1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbYLKX1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:27:23 -0500
Received: from isuela.unizar.es ([155.210.1.53]:43910 "EHLO isuela.unizar.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968AbYLKX1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:27:22 -0500
X-Greylist: delayed 1345 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 18:27:22 EST
Date: Fri, 12 Dec 2008 00:04:52 +0100
From: "J.A. Magallon" <magallon@unizar.es>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Is there something like multi-device fan out ?
Message-ID: <20081212000452.0ff5dfd9@werewolf.home>
Organization: GIGA
X-Mailer: Claws Mail 3.6.1cvs67 (GTK+ 2.14.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Mail-Scanned: Criba 2.0 + Clamd & Bogofilter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

I suspect this sounds like a strange question.
A friend has a company that distributes his own catalogs on CD-ROM, and wants
to build a mass-burning box (something like 8 CD/DVD burners), running linux.

The problem is how to burn an image at the same time to all writers.
I could write a script, but I think this would launch 8 reads on the same
iso file, all desynchronized, that will drive nuts the disk.
Is there any way to get all the /dev/sr? devices and build something like
a fan-out device, or like a RAID1-CDROM or whatever ?
I suppose it has to be done at the kernel level...

TIA

-- 
J.A. Magallon                       \                     Software is like sex:
                                     \               It's better when it's free
Mac OS X Leopard 10.5.5 (build 9F33) x86-64 - Darwin Kernel 9.5.0
