Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbYIKHYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbYIKHYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYIKHYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:24:33 -0400
Received: from divinity.tty.gr ([212.89.179.170]:38371 "EHLO mail.tty.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbYIKHYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:24:32 -0400
X-Greylist: delayed 2986 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2008 03:24:32 EDT
Message-ID: <48C8BC17.5050508@debian.org>
Date: Thu, 11 Sep 2008 09:35:03 +0300
From: Faidon Liambotis <paravoid@debian.org>
Organization: Debian
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: dwmw2@infradead.org, jeffm@suse.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
References: <48C68507.6000609@suse.com>	<1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net>
In-Reply-To: <20080910.160505.14060698.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
>> Firmware really _isn't_ version-specific.
> 
> Tell that to every Debian and Debian derived system on the planet.
> 
> To my knowledge, it is only fedora and possibly one or two other dists
> that put the firmware files in a unary /lib/firmware location, rather
> than a versioned /lib/firmware/$KERNELRELASE one.
[not speaking on behalf of the project, the kernel team or the
respective maintainers]

Apparently and afaik you are misinformed:

$ dpkg -L firmware-bnx2 (or [1])
...
/lib/firmware/bnx2-06-4.0.5.fw
/lib/firmware/bnx2-09-4.0.5.fw
...

$ dpkg -L firmware-iwlwifi (or [2])
...
/lib/firmware/iwlwifi-3945-1.ucode
/lib/firmware/iwlwifi-4965-1.ucode
/lib/firmware/iwlwifi-4965-2.ucode
...

$ dpkg -L firmware-qlogic (or [3])
...
/lib/firmware/ql2100_fw.bin
/lib/firmware/ql2200_fw.bin
/lib/firmware/ql2300_fw.bin
/lib/firmware/ql2322_fw.bin
/lib/firmware/ql2400_fw.bin
/lib/firmware/ql2500_fw.bin
...

etc. for the other firmware packages[4].

Regards,
Faidon

1: http://packages.debian.org/sid/all/firmware-bnx2/filelist
2: http://packages.debian.org/sid/all/firmware-iwlwifi/filelist
3: http://packages.debian.org/sid/all/firmware-qlogic/filelist
4: http://packages.debian.org/firmware
