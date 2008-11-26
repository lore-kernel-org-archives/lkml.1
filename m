Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYKZL1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYKZL1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYKZL1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:27:40 -0500
Received: from mercuryimc.plus.com ([80.229.200.144]:36056 "EHLO
	mimc.mimc.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbYKZL1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:27:39 -0500
Message-ID: <492D32A5.2060300@mimc.co.uk>
Date: Wed, 26 Nov 2008 11:27:33 +0000
From: Mark Jackson <mpfj@mimc.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, mrustad@gmail.com
Subject: Re: Help using initramfs
References: <492C6238.7060507@mimc.co.uk> <492C676A.6020901@zytor.com> <492D2A2A.905@mimc.co.uk>
In-Reply-To: <492D2A2A.905@mimc.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Jackson wrote:

<snip>

> My next problem is this ... below is a copy of my /init script ...
> 
> #!/bin/sh
> #Mount things needed by this script
> mount -t proc proc /proc
> mount -t sysfs sysfs /sys
> mdev -s
> echo "wibble"
> echo "qwerty" > /dev/console
> exec /sbin/init
> exit 0
> 
> And this is the console output ...
> 
> mount: permission denied. (are you root?)
> mount: permission denied. (are you root?)

<snip>

> Does /init not inherently run as root ?
> 
> If not, how do I fix the problem ?

Doh ... fixed.

I didn't had busybox owner set to root.

I'm now up and running !!

Thanks
