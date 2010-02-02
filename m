Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0BBGpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:45:33 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:38493 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0BBGpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:45:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Cx0R3qhvg7XNXOpXxom1haz5Ab4Hh376sRQLEVolQiKDov2ePfJGxepQQa0xzYiNu9
         rCECntv07j9M3BgUCwtSKyodSzOa6FBBbD11U3CnLY2MoWr/X9yMbwBodEI1/2uq+Bgn
         iRr58RILZC1xiA56KY/lMPz0vkzwfK0UFeOTo=
Message-ID: <4B67CA62.8050901@gmail.com>
Date: Mon, 01 Feb 2010 22:46:58 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Dan Carpenter <error27@gmail.com>, linux1394-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug #14487] PANIC:
 early exception 08 rip 246:10 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de>
In-Reply-To: <4B67BC12.4080709@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.k. I feel really stupid right now.
after starring at this for some time I didn't even
think to do a git revert to test other
kernel versions(duh!!).

so doing a git revert to v2.6.27 ohci1394_dma
boots up fine.
a bit late now to do a bisect, but in the morning
I'll start this and see what I get from it, then
go from there.

(man!! let this be a lesson for me);

Justin P. Mattock
