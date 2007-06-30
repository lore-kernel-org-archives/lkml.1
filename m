Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbXF3J2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbXF3J2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbXF3J2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:28:03 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54325 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754446AbXF3J2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:28:00 -0400
Date: Sat, 30 Jun 2007 02:26:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Monakhov <dmonakhov@sw.ru>, Len Brown <lenb@kernel.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, corentincj@iksaif.net,
       sziwan@users.sourceforge.net, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops on rmmod asus_acpi
Message-Id: <20070630022644.20822e6b.akpm@linux-foundation.org>
In-Reply-To: <20070628075551.GA10551@localhost.sw.ru>
References: <Pine.LNX.4.64.0706272113120.11120@fbirervta.pbzchgretzou.qr>
	<20070628075551.GA10551@localhost.sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 11:55:52 +0400 Dmitry Monakhov <dmonakhov@sw.ru> wrote:

> On 21:16 Срд 27 Июн     , Jan Engelhardt wrote:
> > Hi,
> > 
> > 
> > 
> > 	modprobe asus_acpi
> > 	rmmod asus_acpi
> > 
> > is all that is needed to trigger an Oops in 2.6.22-rc6 (x86).
> > If you need more info, please let me know, thanks.
> > 
> > Note that the machine is not ASUS at all (vmware).
> > (But suse_factory loads asus_acpi anyway -wtf?!)
> Fixed in -mm tree by asus_acpi-fix-oops-on-non-asus-machines.patch

That patch disappeared into the acpi git tree a week ago and hasn't emerged
since.

I shall resurrect it and will send it to Linus tomorrow.
