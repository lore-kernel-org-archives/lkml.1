Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZKBVtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZKBVtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbZKBVtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:49:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:60815 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbZKBVtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:49:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YCoeJKKubtH4tUFxmuDvTut8ur2+K7J+EncYlNi3oFPRllt44d5fkXXW5mEikhTQq9
         BUKXX7JxJlHEBKRsXZhryzF9Xzk+QB14Wjm1WOSP0NpKAn3lXxVCwZTH0gP7n+ROxM7q
         nRum8hW0eeV/cU2IjcwyA3hYfJOmSOl2dxCww=
Message-ID: <4AEF53F5.4020107@gmail.com>
Date: Mon, 02 Nov 2009 22:49:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>
In-Reply-To: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 10:29 PM, Justin Mattock wrote:
> [  532.942324] cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
> [  532.942330] Pid: 16002, comm: cc1plus Tainted: P
> 2.6.32-rc5-00083-g04ea458 #2
> [  532.942333] Call Trace:
> [  532.942342]  [<ffffffff810bce11>] T.417+0x7c/0x245
> [  532.942347]  [<ffffffff810bd11c>] __out_of_memory+0x142/0x159
> [  532.942352]  [<ffffffff810bd1a1>] out_of_memory+0x6e/0x9d
> [  532.942357]  [<ffffffff810c0086>] __alloc_pages_nodemask+0x47e/0x5cc
> [  532.942363]  [<ffffffff810d2115>] handle_mm_fault+0x25d/0x68e
> [  532.942369]  [<ffffffff813dfc1d>] do_page_fault+0x2bb/0x2d3
> [  532.942373]  [<ffffffff813ddb25>] page_fault+0x25/0x30
...
> [  532.957951] Out of memory: kill process 16001 (c++) score 543727 or a child
> [  532.957955] Killed process 16002 (cc1plus)
> 
> I just compiled the latest gcc snapshot a few days
> ago.

How many jobs did you run in parallel? Was there anything else memory
consuming running on that machine? Do you run the same jobs count every
time you compile such big c++ projects?
