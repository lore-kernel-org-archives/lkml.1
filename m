Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbXFPGqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbXFPGqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 02:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbXFPGqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 02:46:43 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:16835 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbXFPGqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 02:46:43 -0400
Date: Sat, 16 Jun 2007 08:46:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
cc: Christian Schmidt <lkml@digadd.de>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Help needed: Partitioned software raid > 2TB
In-Reply-To: <46737747.1050608@ums.usu.ru>
Message-ID: <Pine.LNX.4.64.0706160844230.32724@fbirervta.pbzchgretzou.qr>
References: <46727E7C.8060102@digadd.de> <p73d4zxs2q4.fsf@bingen.suse.de>
 <46729C14.5000809@digadd.de> <Pine.LNX.4.64.0706151824240.32724@fbirervta.pbzchgretzou.qr>
 <46737747.1050608@ums.usu.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 16 2007 11:38, Alexander E. Patrakov wrote:
> Jan Engelhardt wrote:
>> On Jun 15 2007 16:03, Christian Schmidt wrote:
>
>> > Thanks for the clarification. I didn't use LVM on the device on purpose,
>> > as root on LVM requires initrd (which I strongly dislike as
>> > yet-another-point-of-failure). As LVM is on the large partition anyway
>> > I'll just add the second partition for now, and change the system setup
>> > with the next drive migration. Maybe linux even supports root-on-lvm
>> > natively until then ;)
>> 
>> Uh, it does. By means of initrd/ramfs image. Blame your distro if it still
>> can't do root-on-LVM, there is at least one who can.
>
> AFAIK, root-on-LVM on the whole disk (BTW, I use such setup myself)
> requires LILO, doesn't it? Could you please list a few distributions
> with an easy method to install LILO (and, of course, root and /boot on
> LVM on whole disk) from their default installation media? So far, I only
> know that Debian can do it if you run debootstrap by hand, although they
> say that such setup is a bug (http://bugs.debian.org/401393).

I am not sure (would have to check again), but I believe both opensuse and
fedora (the latter of which uses LVM for all partitions by default) have
that working, while still using GRUB. But, what's much more amazing, is
that GRUB seems to work with raid0 (both BIOS-based and MD)... perhaps
it's just luck that the needed files are contiguous?

	Jan
-- 
