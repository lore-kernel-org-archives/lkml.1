Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935481Ab0BZLsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:48:07 -0500
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:53723 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935178Ab0BZLsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:48:04 -0500
Message-ID: <4B87B5A4.2010106@ge.com>
Date: Fri, 26 Feb 2010 11:51:00 +0000
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: linuxppc-dev list <linuxppc-dev@ozlabs.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Sandeep Gopalpet <Sandeep.Kumar@freescale.com>, davem@davemloft.net,
       Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Gianfar driver failing on MPC8641D based board
References: <4B6C2488.3060403@ge.com> <4B865176.7080806@ge.com> <4B86A97E.6050509@ge.com> <20100225165141.GA9686@oksana.dev.rtsoft.ru>
In-Reply-To: <20100225165141.GA9686@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> On Thu, Feb 25, 2010 at 04:46:54PM +0000, Martyn Welch wrote:
> [...]
>   
>>> nfs: server 192.168.0.1 not responding, still trying
>>>   
>>>       
>> Further testing has shown that this isn't restricted to warm reboots, it
>> happens from cold as well. In addition, the exact timing of the failure
>> seems to vary, some boots have got further before failing.
>>     
>
> Unfortunately I don't have any 8641 boards near me, so I can't
> debug this myself. Though, I tested gianfar on MPC8568E-MDS with
> 2.6.33 kernel, and it seems to work just fine.
>
> I see you use SMP. Can you try to turn it off? If that will fix
> the issue, then it'll be a good data point.
>
> Meanwhile, I'll try SMP kernel on MPC8568 (UP), and let you
> know the results.
>
> Thanks

I removed the second core from the dts file rather than truly disabling
SMP in the kernel config. Doing this allowed the board to boot reliably.

Martyn

-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189

