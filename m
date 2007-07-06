Return-Path: <linux-kernel-owner+w=401wt.eu-S1763431AbXGFMy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431AbXGFMy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbXGFMyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:54:20 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:43266 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbXGFMyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=W+MKEcm8hRPkFRhDsBIP7VXqYAnRJHqoFLYGNvMZXqzhsXqu9llOn3tsHXCMPTlrRWPfUkTILmTwku/YmmnWf3DpfVtNCNcI+mldGeKpd5+JjYe/HNWxHF0IhcwJbONskqf/iO/HnpLHc+WjTahCdT5TPLy2EKLx0/4sNvV2Dqs=
Message-ID: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com>
Date: Fri, 6 Jul 2007 14:54:18 +0200
From: mikie <mikie.pl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: understanding firmware loader for speedtouch (kernel 2.6.21.5)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I experience some problems with the speedtch.c module, especially in
regards to its firmware loader.
I am not quite sure if this module is going to load the firmware
itself or does it use some external software to do that ?

All I get is :

Jul  6 13:41:37 srv kernel: speedtch 1-2:1.0: speedtch_find_firmware:
looking for speedtch-1.bin.2.00
[...]
Jul  6 13:42:19 srv kernel: speedtch 1-2:1.0: speedtch_find_firmware:
looking for speedtch-1.bin.2
[...]
Jul  6 13:43:19 srv kernel: speedtch 1-2:1.0: speedtch_find_firmware:
looking for speedtch-1.bin

And nothing more happens. The firmware does not get loaded to the
modem. There is also no information in the logs that the firmware
loading failed...

It is worth noting that I use slackware distro, that was installed
long time ago with 8.1 (or 9.0) CD version, and I only make package
upgrades. I used to work with kernel 2.4.33.3 (I compile the kernel
myself), but now decided I switch to the new 2.6 series. The old
distro means that I do not use hotplug nor udevd in my system (and
would like to stick with that scenario, if possible).

I have read and checked the firmware.agent script from some hotplug
package, and noticed that it makes something like simple file copy of
the firmware to the "data" and echoing 1 or 0 to the "loading" file.
But what is the location of these data/loading ? Also the firmware is
split into 2 parts -- should I upload them one after another? Is that
all that should be done to get the firmware loaded?

Regards,
MK
