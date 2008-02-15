Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYBOQuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYBOQuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYBOQuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:50:46 -0500
Received: from Mail.MNSU.EDU ([134.29.1.12]:57250 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbYBOQup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:50:45 -0500
X-Greylist: delayed 1661 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2008 11:50:45 EST
Message-ID: <47B5BC35.1000700@mnsu.edu>
Date: Fri, 15 Feb 2008 10:22:13 -0600
From: "Jeffrey E. Hundstad" <jeffrey.hundstad@mnsu.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Disk schedulers
References: <20080214162104.GA5347@ics.muni.cz> <Pine.LNX.4.64.0802151541370.30301@fbirervta.pbzchgretzou.qr> <20080215155922.GD4269@ics.muni.cz>
In-Reply-To: <20080215155922.GD4269@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek,

I have to say, that I've heard this subject before, the summary answer 
seems to be, that the kernel can not guess the wishes of the user 100% 
of the time.  If you have a low priority I/O task use ionice(1) to set 
the priority of that task so it doesn't nuke your high priority task.

I have to personal stake in this answer but I can report that for my 
high I/O tasks it does work like a charm.

-- 
Jeffrey Hundstad

Lukas Hejtmanek wrote:
> On Fri, Feb 15, 2008 at 03:42:58PM +0100, Jan Engelhardt wrote:
>   
>> Also consider
>> - DMA (e.g. only UDMA2 selected)
>> - aging disk
>>     
>
> it's not the case.
>
> hdparm reports udma5 is used, if it is reliable with libata.
>
> The disk is 3 months old, kernel does not report any errors. And it has never
> been different.
>
> --
> Luká¹ Hejtmánek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
