Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYJXAJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYJXAJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 20:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYJXAJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 20:09:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:11736 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYJXAJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:09:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=f8VRA5bxUN8PuFkO/F7IG/NXvkIkOiVeaBBK3a7wJc7oWjcc3RPOFycXZR11dKuRoi
         XAZp6oFpc1PaXp9+0RowMRGumyY2QD/fI86fBpyhA2pfHu179UQWQoe+E9pr87hcP8kj
         5LyaSZcSNGbsygAWEbKg0dAlFVvHAh3aP8KbA=
Message-ID: <49011234.7090902@gmail.com>
Date: Thu, 23 Oct 2008 17:09:24 -0700
From: walt <w41ter@gmail.com>
User-Agent: Thunderbird/3.0a2pre (X11; 2008102304)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: commit a802dd0e breaks console keyboard input
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi team,

commit a802dd0eb5fc97a50cf1abb1f788a8f6cc5db635
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Mon Oct 13 23:50:08 2008 +0200

     Call init_workqueues before pre smp initcalls.

This commit causes the console login prompt to ignore my keystrokes
so I'm unable to log in (though ssh works fine).  Oddly, if I hit
ctrl-alt-delete the machine does reboot, but no other keystrokes
appear on the screen or have any effect that I can detect.

No surprise that this problem appears only on my dual-core amd64
machine, while the k7 single processor machine works normally.

I've not seen anyone else complaining on the linux list, so maybe
this is a BIOS bug on the affected machine?  It's an ECS mobo with
a GeForce6100PM-M2 chipset, and I use a ps/2 keyboard.

Thanks.
