Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYESIIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYESIIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYESIIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:08:30 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:44711 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766AbYESII1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:08:27 -0400
X-Greylist: delayed 1104 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2008 04:08:27 EDT
MIME-Version: 1.0
Date: Mon, 19 May 2008 02:49:54 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>, tony@atomide.com,
       linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] MUSB: 2 patches to fix some bug found on Blackfin
In-Reply-To: <386072610805182339n2e141b83q4b8f9804194088e4@mail.gmail.com>
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org> <200805170737.37806.david-b@pacbell.net> <386072610805182339n2e141b83q4b8f9804194088e4@mail.gmail.com>
Message-ID: <71636ee466dd53c366eb11d8fc981e8b@felipebalbi.com>
User-Agent: FelipeBalbi.com Webmail
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 May 2008 14:39:10 +0800, "Bryan Wu" <cooloney@kernel.org> wrote:
> On Sat, May 17, 2008 at 10:37 PM, David Brownell <david-b@pacbell.net>
> wrote:
>> On Saturday 17 May 2008, Bryan Wu wrote:
>>>
>>> We discussed these 4 bugs before. Now we fixed them.
>>> Please review following 2 patches.
>>
>> They looked plausible to me ... though the urb->status
>> one is a bit of a band-aid, and when that field finally
>> vanishes a better fix will be needed.
>>
> 
> OK, so is there any plan for merge the MUSB to mainline and finally to
> remove the urb->status?

I was planing to do this by the end of this year or as soon as I make all
usb if tests pass again. I'm out of tools for that right now :-s

But of course we can check this with more caution since we have this bug
to solve before sending it to mainline.

-- 
Best Regards,

Felipe Balbi
http://felipebalbi.com
me@felipebalbi.com

