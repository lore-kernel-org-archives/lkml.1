Return-Path: <linux-kernel-owner+w=401wt.eu-S1762395AbXIZWTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762395AbXIZWTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbXIZWS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:18:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42080 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbXIZWS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:18:56 -0400
Date: Thu, 27 Sep 2007 00:18:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Oleg Verych <olecom@flower.upol.cz>, Jan Beulich <jbeulich@novell.com>,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: why network devices don't do reference counting? (Re: [PATCH]
 Module use count must be updated as bridges are created/destroyed)
In-Reply-To: <20070926140608.6e6d3d0c@freepuppy.rosehill>
Message-ID: <Pine.LNX.4.64.0709270017120.17414@fbirervta.pbzchgretzou.qr>
References: <46FA2C17.76E4.0078.0@novell.com> <20070926083705.6bc65ea5@fujitsu-loaner>
 <E1Iae5t-0007Sk-Vu@flower> <20070926140608.6e6d3d0c@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 26 2007 14:06, Stephen Hemminger wrote:
>> >
>> > No, network devices don't do reference counting.
>> 
>> Could you explain why, please?
>> 
>> After `udevd` on boot loads lots of unused crap, i surrendered, and use
>> $(rmmod `lsmod | just first column`). Networing bravely wipes away. OK,
>> there are lots of configs: udev, hotplug, modprobe, that somebody might
>> like to fix. But it came to the end with me. I just don't care. So,
>> please answer :)
>
>For hotplug and other reasons, the network developers decided that being
>able to remove a network module at any time was a good thing. It works.

Except that for ipv6.ko, it's all opposite. After modprobe,
it already got a refcount like 8 and you're wondering how
to get rid of that.

