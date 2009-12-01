Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZLAKUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZLAKUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZLAKUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:20:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbZLAKUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:20:30 -0500
Message-ID: <4B14EDE3.5050201@redhat.com>
Date: Tue, 01 Dec 2009 11:20:19 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: mchehab@redhat.com, awalls@radix.net, dmitry.torokhov@gmail.com,
       j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, jonsmirl@gmail.com,
       khc@pm.waw.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDodf9W1qgB@lirc>
In-Reply-To: <BDodf9W1qgB@lirc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hi,

>> The point is that for simple usage, like an user plugging his new USB stick
>> he just bought, he should be able to use the shipped IR without needing to
>> configure anything or manually calling any daemon. This currently works
>> with the existing drivers and it is a feature that needs to be kept.
>
> Admittedly, LIRC is way behind when it comes to plug'n'play.

Should not be that hard to fixup.

When moving the keytable loading from kernel to userspace the kernel 
drivers have to inform userspace anyway what kind of hardware the IR 
device is, so udev can figure what keytable it should load.  A sysfs 
attribute is the way to go here I think.

lirc drivers can do the same, and lircd can startup with a reasonable 
(default) configuration.

Of course evdev and lirc subsytems/drivers should agree on which 
attributes should be defined and how they are filled.

cheers,
   Gerd
