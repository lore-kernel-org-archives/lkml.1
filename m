Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab0BQN0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:26:53 -0500
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:54701 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932987Ab0BQN0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:26:50 -0500
From: Frans Pop <elendil@planet.nl>
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 14:26:46 +0100
User-Agent: KMail/1.9.9
Cc: kyle@moffetthome.net, neilb@suse.de, babydr@baby-dragons.com,
       davidsen@tmr.com, volkerarmin@googlemail.com, mjevans1983@gmail.com,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com> <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com> <201002141940.35716.volkerarmin@googlemail.com> <4B7AD35E.7000405@tmr.com> <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com> <20100217130103.3ca65ef3@notabene.brown> <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com> <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com> <4B7BB927.5000305@grumpydevil.homelinux.org>
In-reply-To: <4B7BB927.5000305@grumpydevil.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002171426.47981.elendil@planet.nl>
X-OriginalArrivalTime: 17 Feb 2010 13:26:48.0163 (UTC) FILETIME=[DB5BBB30:01CAAFD4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rudy Zijlstra wrote:
> 1/ distro tools assume that the kernel being build will run on that
> machine. For servers this is often not true. There are very valid
> security reasons to exclude compilation capability from many servers.

That's simply not true, at least not for Debian. If you actually use the 
distro tools [1] the only assumptions are made at kernel *installation* 
time, not at kernel build time.

I've been using initramfs-tools generated initrds for years without 
problems, and that includes "root on LVM on LUKS encrypted partition" 
and "root on LVM on RAID" setups.

Cheers,
FJP

[1] I.e. if you build and install the kernel as a .deb package using e.g. 
the deb-pkg target or kernel-package.
