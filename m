Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYJBWV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYJBWV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYJBWVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:21:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:37450 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbYJBWVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=Q1ftgW72lAKVlK/BCIyctpzGkq06OrzHuD9crwVc0+jZW8/+91NGuFS9lVcB59qHXS
         F//PxD7zQaOnfVlq02dsIc5Xv2pOL00gCPqDD+wJXu3PjNbDq3nKn/xl7npZKpdD+fJd
         z6xrDBb90uUQncr+wVePy58dncz2rA3JpzR9E=
Message-ID: <48E54978.8040209@devnull.org>
Date: Fri, 03 Oct 2008 00:21:44 +0200
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: FYI: e1000e: corruption, Lenovo/IBM are replacing my MB.
References: <biEdH-1q1-15@gated-at.bofh.it> <biEdH-1q1-13@gated-at.bofh.it> <biEx3-1ZX-17@gated-at.bofh.it>
In-Reply-To: <biEx3-1ZX-17@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
From: Niel Lambrechts <niel.lambrechts@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2008 12:10 AM, Kok, Auke wrote:
> your mac address certainly still looks ok, and from quickly browsing this eeprom
> content certainly looks valid. (most eeproms indeed END in all 0xff bytes).

Thanks for clarifying that, I suspected it to be the case, but wanted
confirmation since it is a new company laptop :O

The first thing I did was to reboot in 2.6.25 and verify the ethernet -
it was fully functional via DHCP.

Also to me, the MAC address seems fine:
linux-7vph:/ # ifconfig eth0
eth0      Link encap:Ethernet  HWaddr 00:1C:25:95:93:EC
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
          Memory:fc200000-fc220000

(Right now, I'm using iwlagn, not ethernet)

> does the e1000e driver still load? do you get 'bad eeprom checksum' errors on boot?

Well it loads fine now, but this is after I have switched back to 2.6.26.5.

Too scared to try 2.6.27 again, but I definitely saw a boot message in
an asterisk surrounded block that said something about NVRAM checksum(?)...

>From some of the earlier posts I read that this bug surfaced on s2ram /
s2disk, not sure if there are other corruption "triggers".

Regards,
Niel
