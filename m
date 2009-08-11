Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbZHKMI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbZHKMI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZHKMI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:08:57 -0400
Received: from smtp.nokia.com ([192.100.122.230]:23783 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZHKMIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:08:55 -0400
Message-ID: <4A810DE4.7030202@gmail.com>
Date: Tue, 11 Aug 2009 09:21:24 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: vimal singh <vimal.newwork@gmail.com>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
       dedekind@infradead.org, linux-kernel@vger.kernel.org,
       david-b@pacbell.net, linux-mtd@lists.infradead.org,
       vimal singh <vimalsingh@ti.com>, dwmw2@infradead.org
Subject: Re: [PATCH-v3 1:2] [MTD][NAND]omap: Adding support for nand prefetch-read
 and post-write, in MPU mode.
References: <61339.192.168.10.89.1247226725.squirrel@dbdmail.itg.ti.com> 	<48097.192.168.10.89.1247232736.squirrel@dbdmail.itg.ti.com> 	<60361.192.168.10.89.1247482584.squirrel@dbdmail.itg.ti.com> 	<20090810162734.GH1938@atomide.com> <ce9ab5790908102245r28224bf5nfa2a1b22267767fe@mail.gmail.com>
In-Reply-To: <ce9ab5790908102245r28224bf5nfa2a1b22267767fe@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Aug 2009 06:23:05.0677 (UTC) FILETIME=[2FE3B7D0:01CA1A4C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 08:45 AM, vimal singh wrote:
> On Mon, Aug 10, 2009 at 9:57 PM, Tony Lindgren<tony@atomide.com>  wrote:
>> * vimal singh<vimalsingh@ti.com>  [090713 13:56]:
>>> Patch updated for ' ioreadX / iowriteX and ioreadX_rep / iowriteX_rep' as per
>>> David Brownell's comment. I updated 'omap_(read/write)_buf16' fucntions also
>>> for this.
>>>
>>> -vimal
>>>
>>> This patch adds prefetch support to access nand flash in mpu mode.
>>> This patch also adds 8-bit nand support (omap_read/write_buf8).
>>> Prefetch can be used for both 8- and 16-bit devices.
>>>
>>> Signed-off-by: Vimal Singh<vimalsingh@ti.com>
>> Sorry for the delay. I've looked at the GPMC part, and that now looks OK
>> to me. So I'm OK for this to get integrated via the MTD list.
>>
>> Acked-by: Tony Lindgren<tony@atomide.com>
>>
>
> Can you give your ack to below patch too?
>
> http://lists.infradead.org/pipermail/linux-mtd/2009-July/026373.html

I've picked up both of your patches, please, check:
http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/33f48f597315842f39427ee4261cbf82a9afeaf3
http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/b67d52c91b26e97f981f2c292619d31667d5b272

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
