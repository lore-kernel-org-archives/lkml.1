Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbZHKL70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbZHKL70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZHKL7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:59:24 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:34290 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZHKL7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Riu5dHH1wUGQxN9n+bFylrHCVcctE7Eew1ixlM9vlK4ZVUPTfDKuzHRNePrREA+gnU
         /iwcKMyx115JfENuORED6uH9i3thEwDjP12avJCBlhUTwn9L+ul3qRI229zTt8YKdhCK
         Szt+VI3WaQDkYrPK6ysuv8bXgzKCZeKkykmYc=
MIME-Version: 1.0
In-Reply-To: <4A810DE4.7030202@gmail.com>
References: <61339.192.168.10.89.1247226725.squirrel@dbdmail.itg.ti.com> 
	<48097.192.168.10.89.1247232736.squirrel@dbdmail.itg.ti.com> 
	<60361.192.168.10.89.1247482584.squirrel@dbdmail.itg.ti.com> 
	<20090810162734.GH1938@atomide.com> <ce9ab5790908102245r28224bf5nfa2a1b22267767fe@mail.gmail.com> 
	<4A810DE4.7030202@gmail.com>
From: vimal singh <vimal.newwork@gmail.com>
Date: Tue, 11 Aug 2009 11:59:15 +0530
Message-ID: <ce9ab5790908102329k73f66b5bgcdd8ac52d6631116@mail.gmail.com>
Subject: Re: [PATCH-v3 1:2] [MTD][NAND]omap: Adding support for nand 
	prefetch-read and post-write, in MPU mode.
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
       dedekind@infradead.org, linux-kernel@vger.kernel.org,
       david-b@pacbell.net, linux-mtd@lists.infradead.org,
       vimal singh <vimalsingh@ti.com>, dwmw2@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 11:51 AM, Artem Bityutskiy<dedekind1@gmail.com> wrote:
> On 08/11/2009 08:45 AM, vimal singh wrote:
>>
>> On Mon, Aug 10, 2009 at 9:57 PM, Tony Lindgren<tony@atomide.com>  wrote:
>>>
>>> * vimal singh<vimalsingh@ti.com>  [090713 13:56]:
>>>>
>>>> Patch updated for ' ioreadX / iowriteX and ioreadX_rep / iowriteX_rep'
>>>> as per
>>>> David Brownell's comment. I updated 'omap_(read/write)_buf16' fucntions
>>>> also
>>>> for this.
>>>>
>>>> -vimal
>>>>
>>>> This patch adds prefetch support to access nand flash in mpu mode.
>>>> This patch also adds 8-bit nand support (omap_read/write_buf8).
>>>> Prefetch can be used for both 8- and 16-bit devices.
>>>>
>>>> Signed-off-by: Vimal Singh<vimalsingh@ti.com>
>>>
>>> Sorry for the delay. I've looked at the GPMC part, and that now looks OK
>>> to me. So I'm OK for this to get integrated via the MTD list.
>>>
>>> Acked-by: Tony Lindgren<tony@atomide.com>
>>>
>>
>> Can you give your ack to below patch too?
>>
>> http://lists.infradead.org/pipermail/linux-mtd/2009-July/026373.html
>
> I've picked up both of your patches, please, check:
> http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/33f48f597315842f39427ee4261cbf82a9afeaf3
> http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/b67d52c91b26e97f981f2c292619d31667d5b272
>

Thanks Artem.

> --
> Best Regards,
> Artem Bityutskiy (Артём Битюцкий)
>
