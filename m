Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0BOHHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:07:14 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:46997 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab0BOHHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:07:12 -0500
Message-ID: <4B78EE15.9020407@shikadi.net>
Date: Mon, 15 Feb 2010 16:47:49 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: UML broken - runaway loop modprobe binfmt-464c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've been forced to upgrade an old machine running a couple of UML VMs, but I 
can't for the life of me figure out how to make them work on the new machine.

I've compiled the latest kernel from kernel.org with ARCH=um and when I run it 
says this a few times and then stops:

request_module: runaway loop modprobe binfmt-464c

 From Google it appears the cause of this is when you run a 64-bit system with 
a 32-bit kernel, but I'm running a 64-bit kernel with a 32-bit system.  I 
vaguely recall something about IA32 emulation in the normal kernel build, but 
I can't see anything like that in the UML kernel config.

Does anyone know what might fix this?

Many thanks,
Adam.

(please CC)
