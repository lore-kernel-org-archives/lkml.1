Return-Path: <linux-kernel-owner+w=401wt.eu-S965673AbXAYHdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673AbXAYHdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 02:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965674AbXAYHdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 02:33:36 -0500
Received: from fil.mine.nu ([82.240.81.52]:50616 "EHLO fil.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965673AbXAYHdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 02:33:35 -0500
Message-ID: <45B85D48.9080403@laposte.net>
Date: Thu, 25 Jan 2007 08:33:28 +0100
From: Vince <fuzzy77@laposte.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: "Vladimir V. Saveliev" <vs@namesys.com>
CC: reiserfs-list@namesys.com, Andrew Morton <akpm@osdl.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.20-rc4-mm1 Reiser4 filesystem freeze and corruption
References: <1169229490.6266.11.camel@oberon> <45B5BB5E.4010802@laposte.net> <200701232215.37321.vs@namesys.com>
In-Reply-To: <200701232215.37321.vs@namesys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vladimir V. Saveliev wrote:
> Hello
> 
> On Tuesday 23 January 2007 10:38, Vince wrote:
[...]
>> I don't know if it is related, but I've had the following BUG on 
>> 2.6.20-rc4-mm1 (+ hot-fixes patches applied) :
>>
>> -------------------
>> kernel BUG at fs/reiser4/plugin/item/extent_file_ops.c:973!
> 
> This is another problem than Zan's one. The attached patch should fix it.
> 
> Andrew, please apply.
> 
> 
> From: Vladimir Saveliev <vs@namesys.com>
> 
> remove_suid may open a transaction in reiser4 which is to be restarted
> before entering into main write loop.
> 
> Signed-off-by: Vladimir Saveliev <vs@namesys.com>

I'm pleased to confirm I wasn't able to reproduce the bug with your 
patch applied.

Regards,

Vince
