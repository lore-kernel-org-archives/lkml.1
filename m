Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbXCDRNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbXCDRNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 12:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXCDRNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 12:13:23 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:59105 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbXCDRNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 12:13:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WBxjExBSA/+XINAzH/NGhNYz9Or/xfru3BKBo+uLIxsMxecC7qwB3NJVdXWQOrd8bxaSz3CiizTU3ZTL6NuKWXCjADW7vn/qIBS0QAqarAwq1rMGG/f/iwVscLXuoVk2eZfYHoARhnoEkP6CNzjEVdnfH2G/lVFAs08PEJV+2zU=
Message-ID: <6bffcb0e0703040913g5e9131f1gf8036207a1b78203@mail.gmail.com>
Date: Sun, 4 Mar 2007 18:13:20 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
Subject: Re: 2.6.21-rc2-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200703041806.01621.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	 <20070304033445.cff1148f.akpm@linux-foundation.org>
	 <200703041301.09121.m.kozlowski@tuxland.pl>
	 <200703041806.01621.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/07, Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> > I'll dig some more and try to catch some data.
>
> Ok. I started the system and it froze after approx. 5 min. of uptime.
>
> Scenario:
>
> - I logged into kde
> - started aterm
> - insmod netconsole ... blah blah
> - started azureus (downloading 1 torrent)
> - started firefox (pandora.com -> flash playing music)
> - started aterm
> - started kmail
>
> -> fool around a bit and ... whoops -> system is frozen
>
> Symptoms:
> - I left the computer running frozen for 5~10 minutes just in case it suddenly 'regain consciousness'
> - num lock, caps lock do not make the leds on/off (looks like dead keyboard)
> - unable to switch to console
> - I issued sysrq-p, sysrq-t, the computer still looks dead but surprise! netconsole worked and I managed
>   to capture some data, no oops though
> - sysrq-s does not work -> only "SysRq : Emergency Sync" gets printed ("Emergency Sync complete" does
>   not appear)
> - hard drive I/O is dead (led not blinking when sysrq-s or whatever)
> - computer is totaly unresponsive and issuing sysrq looks like playing with dead computer
> - the only thing to at this stage is is hard reset
>
> Almost each time the frozen system looks a bit different. So not sure where to look exactly. Sometimes
> the keyboard 'works' and I can switch to console, sometimes the box looks totally dead, sometimes it
> loops some short fragment of music and makes weird sounds, sometimes azureus still works (wifi traffic led
> is blinking), sometimes CPU is eaten up, sometimes not. The common denominator could be no hard drive I/O
> activity.
>
> I read Michal P. report and it might be that we hit the same bug here.
>
> Below you'll find the output and current config attached.
>
> --------
>
> Loglevel set to 7
> SysRq : Show Regs
>
> Pid: 12322, comm:          firefox-bin

It looks familiar.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
