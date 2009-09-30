Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZI3RoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZI3RoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZI3RoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:44:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:36952 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZI3RoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:44:17 -0400
Date: Wed, 30 Sep 2009 19:44:47 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: "Steven A. DuChene" <linux-clusters@mindspring.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Warning: unable to open an initial console
Message-ID: <20090930194447.016e66c3@infradead.org>
In-Reply-To: <31532395.1254330324879.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
References: <31532395.1254330324879.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 13:05:24 -0400 (EDT)
"Steven A. DuChene" <linux-clusters@mindspring.com> wrote:

> Hmm, I tried various combonations of turning off the framebuffer
> support all together and then turning it back on with various
> drivers (nvidia or vesa vga) but still I get the same message
> about "Warning: unable to open an initial console."
> 
> Anything else I should be looking at besides the graphics support
> part of the drivers section of the kernel config?
> 
> Again this is a fairly standard PCChips A13G motherboard with
> NVidia chipset and AMD Athlon 3600+ CPU that works fine with the
> regular distro supplied FC9 kernel (2.6.25-14.fc9.x86_64) and
> I have the x86_64 version of FC9 installed.


on FC9 ....
here's what to do on a successful boot

mkdir /tmp/mnt2
mount /dev/sdaX /tmp/mnt  
(where the X is your root device, if you use lvm, mount the lvm thing
there)
cp -a /dev/console /tmp/mnt/dev/console
umount /tmp/mnt2

