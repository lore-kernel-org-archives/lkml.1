Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbXISSYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbXISSYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbXISSYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:24:35 -0400
Received: from mail.tmr.com ([64.65.253.246]:52360 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128AbXISSYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:24:35 -0400
Message-ID: <46F16A0A.3070402@tmr.com>
Date: Wed, 19 Sep 2007 14:27:22 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: majkls <majkls@prepere.com>, bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <46F0CD96.9030807@prepere.com> <20070919104018.3a6bcfb1@the-village.bc.nu>
In-Reply-To: <20070919104018.3a6bcfb1@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 19 Sep 2007 09:19:50 +0200
> majkls <majkls@prepere.com> wrote:
> 
>> Hello,
>> here is an fix to an exploit (obtained somewhere in internet). This 
>> exploit can workaround chroot with CAP_SYS_CHROOT. It is also possible 
>> (with sufficient filedescriptor (if there is na directory fd opened in 
>> root) workaround chroot with sys_fchdir. This patch fixes it.
> 
> 
> If you have the ability to use chroot() you are root. If you are root you
> can walk happily out of any chroot by a thousand other means.
> 
I thought this was to prevent breaking out of chroot as a normal user.
	ie. chroot /var/myjail /bin/su - guest
or similar.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
