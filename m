Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbXFPFiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbXFPFiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 01:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXFPFiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 01:38:08 -0400
Received: from relay4.usu.ru ([194.226.235.39]:58491 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbXFPFiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 01:38:07 -0400
Message-ID: <46737747.1050608@ums.usu.ru>
Date: Sat, 16 Jun 2007 11:38:15 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Christian Schmidt <lkml@digadd.de>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Help needed: Partitioned software raid > 2TB
References: <46727E7C.8060102@digadd.de> <p73d4zxs2q4.fsf@bingen.suse.de> <46729C14.5000809@digadd.de> <Pine.LNX.4.64.0706151824240.32724@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706151824240.32724@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 15 2007 16:03, Christian Schmidt wrote:

>> Thanks for the clarification. I didn't use LVM on the device on purpose,
>> as root on LVM requires initrd (which I strongly dislike as
>> yet-another-point-of-failure). As LVM is on the large partition anyway
>> I'll just add the second partition for now, and change the system setup
>> with the next drive migration. Maybe linux even supports root-on-lvm
>> natively until then ;)
> 
> Uh, it does. By means of initrd/ramfs image. Blame your distro if it still
> can't do root-on-LVM, there is at least one who can.

AFAIK, root-on-LVM on the whole disk (BTW, I use such setup myself) requires 
LILO, doesn't it? Could you please list a few distributions with an easy 
method to install LILO (and, of course, root and /boot on LVM on whole disk) 
from their default installation media? So far, I only know that Debian can 
do it if you run debootstrap by hand, although they say that such setup is a 
bug (http://bugs.debian.org/401393).

-- 
Alexander E. Patrakov
