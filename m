Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYAONIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYAONIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbYAONIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:08:12 -0500
Received: from pc1.vlan1105.bsn.no ([193.239.155.190]:53769 "EHLO
	perrin.robotmafia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYAONIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:08:11 -0500
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 08:08:11 EST
Date: Tue, 15 Jan 2008 13:58:54 +0100
From: =?iso-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?= <lorrides@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080115125854.GA2196@robotmafia.org>
References: <20071225032605.29147200@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071225032605.29147200@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just thought this might be interesting to the discussion.

I recently bought another 2 GB memory for my computer.
My hardware is as following:

Asus Commando (Intel P965 chipset)
Intel Core2 Q6600
4x1 GB Geil PC6400 memory
nVidia 8800 gts (old g80 core, 640 mb mem)

Without booting with pci=nommeconf i have severe stability issues and
often when its not crashing i get slowdowns with the error:

kern.log:Jan 15 13:19:40 bilbo kernel: [  132.046715] NVRM: Xid
(0001:00): 6, PE0001
... repeated x times.

In addition the nVidia framebuffer seems to "leak" or not update since
i get loads of graphics artifacts.

The system works perfectly fine with 2 GB memory and not the
pci=nommconf.
It works like a charm when using pci=nommconf and 4 GB memory.

In adition i have to enable the Northbridge->PCI Memory remap feature
in the BIOS to avoid the kernel panicing when trying to access > 3 gb
but that is understandable :)

My software is Kubuntu 7.10 stock x86_64 kernel, but i do use the
binary driver by nVidia.

It works like a charm when using pci=nommconf

If you guys need any more info about hardware/software from me, please
let me know.

-- 
Øyvind Vågen Jægtnes
+47 96 22 03 08

(i reject your diurnal rhythm and subsitute my own)
