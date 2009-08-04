Return-Path: <linux-kernel-owner+w=401wt.eu-S933259AbZHDSkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbZHDSkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933144AbZHDSkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:40:14 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43617 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112AbZHDSkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:40:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=e/azYgiY/OsIIHiPsgEh0wLLo0eq7oVtF9eaCRUSdfBcZ6uJ3fN+59D44ZTZrO1nPc
         MqCIwbC2u+YHRjHk0fdtivlhwn01mFdy9CnppGEZLSIInD60Hi/zWYGOiqfYOVRPYC6b
         pUc+78LfftwQudJlZBdmg0adpRH+lIR6Oh8No=
MIME-Version: 1.0
Date: Tue, 4 Aug 2009 20:40:10 +0200
Message-ID: <71cd59b00908041140j7bd814d2u90585864fe00415e@mail.gmail.com>
Subject: Cleaning asus_oled
From: Corentin Chary <corentin.chary@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Jakub Schmidtke <sjakub@gmail.com>, acpi4asus-user@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm trying to clean the asus_oled driver, here is my git tree with
some trivial patchs.
http://git.iksaif.net/?p=acpi4asus.git;a=shortlog;h=refs/heads/asus_oled

Before working deeper, I wanted to discuss about the userspace interface:

> TODO:
> [...]
>        - audit the userspace interface
>                - sysfs vs. char?

First, should we move asus_oled functionalities in asus-laptop ?
Then the interface would be in sysfs under
/sys/devices/platform/asus-laptop/{picture|enable} ?

Else we can use /dev/asus_oled, with an ioctl (or a zero-size image)
to switch the OLED off.
But I don't think /sys/class/oled is a good place to be, because
/sys/class is for generic things.

Thanks,

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
