Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbXHBLrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbXHBLrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbXHBLrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:47:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33091 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388AbXHBLrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:47:41 -0400
Date: Thu, 2 Aug 2007 13:47:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Herbert Rosmanith <kernel@wildsau.enemy.org>
cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
Subject: Re: VIA EPIA EK: strange eth dev numbering
In-Reply-To: <200708021056.l72Au722008603@wildsau.enemy.org>
Message-ID: <Pine.LNX.4.64.0708021347270.24572@fbirervta.pbzchgretzou.qr>
References: <200708021056.l72Au722008603@wildsau.enemy.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 12:56, Herbert Rosmanith wrote:
>> On Aug 2 2007 12:42, Herbert Rosmanith wrote:
>> There never *were* days when eth0 remained eth0 across such changes.
>
>but there *were* days when eth0 was eth0, if the kernel reports it as such.
>now there is no eth0 at all. if I see an "eth0" from dmesg, I expect
>it to be present.

Wait, you forget that something may change the name. That dmesg message
from 1 second ago does not need to be valid anymore, just as anything
else in this world.


On Aug 2 2007 13:12, Herbert Rosmanith wrote:
>> > cards around), eth0 would also suddenly become a different one. There never
>> > *were* days when eth0 remained eth0 across such changes.
>> 
>> but there *were* days when eth0 was eth0, if the kernel reports it as such.
>> now there is no eth0 at all. if I see an "eth0" from dmesg, I expect
>> it to be present.
>
>hm, well, a thought, maybe udev should report what is doing, like
>printinig "renamed eth0 to eth2", or such.

I think it once did with suse, but it does not right now. Worth fixing
(yet I am no udev maintainer).

>the problem with this device renaming in my case was that other software,
>in particular dhcpcd, didnt get any lease, because (obviously?) dhcpcd
>on the other hand _still_ seemed to look for eth0, and thus, after
>booting, there was no network configured at all.

So blame your distro for not integrating udev correctly with dhcp-client.
I can only speak for suse, where you define BOOTPROTO=dhcp for an
interface. Then, on /etc/init.d/network, every interface that has a
configuration file gets run, so you never see what ethX udev picked for
the day, but things still work. That's good^TM.


	Jan
-- 
