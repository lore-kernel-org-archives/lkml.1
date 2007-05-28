Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbXE1IYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbXE1IYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbXE1IYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:24:14 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:44859 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbXE1IYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:24:13 -0400
Message-ID: <465A91AA.1050508@simon.arlott.org.uk>
Date: Mon, 28 May 2007 09:24:10 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Tomas Carnecky <tom@dbservice.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: at mm/slab.c:777 __find_general_cachep()
References: <465A9410.5060606@dbservice.com>
In-Reply-To: <465A9410.5060606@dbservice.com>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/07 09:34, Tomas Carnecky wrote:
> Kernel 2.6.22-rc2-g47b97135, happened while running wine (32bit app) on
> my amd64 box... should I try -rc3?

Yes, commit 6087b2dab2c914268b1a50882edbbad82bfefd29 probably fixed this.
 
> BUG: at mm/slab.c:777 __find_general_cachep()
> 
> Call Trace:
>  [<ffffffff80278146>] __kmalloc+0xa6/0xe0
>  [<ffffffff802ac959>] compat_core_sys_select+0x109/0x290
>  [<ffffffff802ae3f1>] compat_sys_select+0xe1/0x190
>  [<ffffffff8021e124>] cstar_do_call+0x1b/0x65

-- 
Simon Arlott
