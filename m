Return-Path: <linux-kernel-owner+w=401wt.eu-S1764959AbYEFQ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764959AbYEFQ20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYEFQ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:28:16 -0400
Received: from mail.candelatech.com ([66.165.47.212]:36237 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYEFQ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:28:15 -0400
X-Greylist: delayed 1485 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2008 12:28:15 EDT
Message-ID: <4820813D.6050608@candelatech.com>
Date: Tue, 06 May 2008 09:03:09 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, rmk@arm.linux.org.uk,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] NULL pointer dereference in uart_write_room().
References: <261636618@web.de>	<200805022300.GIB30385.FJOVHQSMFtOOFL@I-love.SAKURA.ne.jp>	<200805041716.DDG43279.JOSMHVFOFFQLOt@I-love.SAKURA.ne.jp> <20080505113055.5284052e@core>
In-Reply-To: <20080505113055.5284052e@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> (5) uart_remove_one_port() is called by serial8250_register_port()
>>     since ttyS0 is already in use but it is requested to be once removed.
>>     
>
> That means 8250_pnp is taking over and then trying to delete the console,
> so its breakage in the serial layer glue. Perhaps Russell has some ideas
> as its hard to tell what he intended to happen originally.
>   
For what it's worth, I've been seeing this problem since about 2.6.23 on 
several
different systems, and will be happy to test patches.  The work-around 
of changing
the .config file will be fine in the meantime, it seems.

Thanks,
Ben

> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   


-- 
Ben Greear <greearb@candelatech.com> 
Candela Technologies Inc  http://www.candelatech.com


