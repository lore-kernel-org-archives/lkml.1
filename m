Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbXITSCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbXITSCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbXITSCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:02:14 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34080 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbXITSCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:02:14 -0400
Message-ID: <46F2B59F.8090709@davidnewall.com>
Date: Fri, 21 Sep 2007 03:32:07 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Philipp Marek <philipp@marek.priv.at>
CC: 7eggert@gmx.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <952DN-83o-31@gated-at.bofh.it> <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5>
In-Reply-To: <200709201817.17282@x5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Marek wrote:
> AFAIK pivot_root() changes the / mapping for *all* processes, no?
>   

The manual page is confusing.  It even admits to being "intentionally 
vague".  However the goal seems clear:

    "pivot_root() moves the root file system of the current process to
    the directory put_old and makes new_root the new root file system of
    the current process"
    -- man 2 pivot_root

There's an argument that pivot_root could be improved...
