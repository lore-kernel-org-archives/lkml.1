Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXIZUvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXIZUvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXIZUvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:51:12 -0400
Received: from barikada.upol.cz ([158.194.242.200]:38029 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbXIZUvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:51:11 -0400
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "Jan Beulich" <jbeulich@novell.com>, <bridge@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: why network devices don't do reference counting? (Re: [PATCH] Module use count must be updated as bridges are created/destroyed)
In-Reply-To: <20070926083705.6bc65ea5@fujitsu-loaner>
References: <46FA2C17.76E4.0078.0@novell.com> <20070926083705.6bc65ea5@fujitsu-loaner>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Wed, 26 Sep 2007 23:06:53 +0200
Message-Id: <E1Iae5t-0007Sk-Vu@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Wed, 26 Sep 2007 08:37:05 -0700
* Organization: Linux Foundation
>
> On Wed, 26 Sep 2007 08:53:27 +0100
> "Jan Beulich" <jbeulich@novell.com> wrote:
>
>> Otherwise 'modprobe -r' on a module having a dependency on bridge will
>> implicitly unload bridge, bringing down all connectivity that was
>> using bridges.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>>
>
> No, network devices don't do reference counting.

Could you explain why, please?

After `udevd` on boot loads lots of unused crap, i surrendered, and use
$(rmmod `lsmod | just first column`). Networing bravely wipes away. OK,
there are lots of configs: udev, hotplug, modprobe, that somebody might
like to fix. But it came to the end with me. I just don't care. So,
please answer :)
____
