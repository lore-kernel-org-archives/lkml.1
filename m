Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbZLRNeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbZLRNeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZLRNeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:34:08 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:18405 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751473AbZLRNeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:34:07 -0500
Message-ID: <4B2B8446.4060401@draigBrady.com>
Date: Fri, 18 Dec 2009 13:31:50 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       =?ISO-8859-1?Q?Am=E9r?= =?ISO-8859-1?Q?ico_Wang?= 
	<xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <200912171618.32882.bzolnier@gmail.com> <alpine.LFD.2.00.0912170726230.17868@localhost.localdomain> <200912171708.07899.bzolnier@gmail.com> <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/09 16:21, Linus Torvalds wrote:
> I'd be ok with changing the warning to 132 characters, which is another
> perfectly fine historical limit. Or we can split the difference, and say
> "ok, 106 characters is too much". I don't care. But 80 characters is
> causing too many idiotic changes.

I find smaller limits help when you want to do side-by-side diffs,
or `git blame` for example, but I agree there needs to be taste applied,
so as to not mangle the code.

cheers,
Pádraig.
