Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbXITUvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbXITUvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbXITUu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:50:57 -0400
Received: from mail.tmr.com ([64.65.253.246]:53706 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbXITUu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:50:57 -0400
Message-ID: <46F2DDD0.3030500@tmr.com>
Date: Thu, 20 Sep 2007 16:53:36 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: David Newall <david@davidnewall.com>
CC: Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <952DN-83o-31@gated-at.bofh.it> <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5> <46F2B59F.8090709@davidnewall.com>
In-Reply-To: <46F2B59F.8090709@davidnewall.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Philipp Marek wrote:
>> AFAIK pivot_root() changes the / mapping for *all* processes, no?
>>   
>
> The manual page is confusing.  It even admits to being "intentionally 
> vague".  However the goal seems clear:
>
>    "pivot_root() moves the root file system of the current process to
>    the directory put_old and makes new_root the new root file system of
>    the current process"
>    -- man 2 pivot_root
>
> There's an argument that pivot_root could be improved...
>
And very little argument that the man page could be improved, perhaps. 
However, there is no question that pivot_root is intended to have 
breadth for more than one process.

Keeping this functionality sounds a little like putting a bow tie and 
tux on your bug and calling it a "feature." Not all bugs are useless for 
legitimate purposes, but it doesn't make them safe. It appears to be a 
sort-of way to get per-process bind mounts.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

