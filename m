Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0BNUrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:47:33 -0500
Received: from mx2.isti.cnr.it ([194.119.192.4]:1552 "EHLO mx2.isti.cnr.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab0BNUrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:47:31 -0500
Date: Sun, 14 Feb 2010 21:47:16 +0100
From: Asdo <asdo@shiftmail.org>
Subject: Re: Linux mdadm superblock question.
In-reply-to: <20100214193406.GA15722@khazad-dum.debian.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Michael Evans <mjevans1983@gmail.com>,
       Volker Armin Hemmann <volkerarmin@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Message-id: <4B786154.8090103@shiftmail.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
X-INSM-ip-source: 151.81.210.150 Auth Done
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <20100214193406.GA15722@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Sat, 13 Feb 2010, Michael Evans wrote:
>   
>> I remember hearing that 1.x had /no/ plans for kernel level
>> auto-detection ever.  That can be accomplished in early-userspace
>> leaving the code in the kernel much less complex, and therefore far
>> more reliable.
>>     
>
> Yes, it is far more reliable kernel side, if only because it doesn't do
> anything.
>
> But the userspace reliability is _not_ good.  initrds are a source of
> problems the moment things start to go wrong, and that's when they are not
> the problem themselves.
>
> And the end result is a system that needs manual intervention to get its
> root filesystem back.
>
> In my experience, every time we moved critical codepaths to userspace, we
> ended up decreasing the *overall* system reliability.
>   
I don't see it like this.
You have the same chance to screw up the system by making mistakes in 
the files in /etc, in the networking config, the firewall, the server 
applications...
(note: I speak for Debian/Ubuntu, redhat's initramfs I think is more messy.)
1.x autodetection worked great for me in initramfs. Basically you only 
need /etc/mdadm/mdadm.conf copied to initramfs (via update-initramfs), 
the rest is done by Debian/Ubuntu standard initramfs procedure.
Also consider 1.x allows to choose which arrays are autoassembled 
(hostname written in the array name equal to hostname in the machine or 
specified in mdadm.conf): this is more precise than 0.9 which 
autoassembles all, I think.
