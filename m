Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbZCXNKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbZCXNKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZCXNKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:10:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:36006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbZCXNKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:10:36 -0400
Message-ID: <49C8DB12.8090709@kernel.org>
Date: Tue, 24 Mar 2009 22:07:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       =?ISO-8859-1?Q?J=F6?= =?ISO-8859-1?Q?rg_Dorchain?= 
	<joerg@dorchain.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Tim Waugh <tim@cyberelk.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH 15/17] block: kill end_request()
References: <1237170540-19130-1-git-send-email-tj@kernel.org> <1237170540-19130-16-git-send-email-tj@kernel.org> <49C457C3.6080909@kernel.org> <20090324113701.GL27476@kernel.dk>
In-Reply-To: <20090324113701.GL27476@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 13:07:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

Jens Axboe wrote:
> The patchset is no longer in the for-2.6.30 upstream branch of the block
> git repo, due to the this glitch and the debate on ide conflicts (which
> I still find extremely silly and an over reaction).
> 
> I trust you will resend it when you are ready!

Yeap, everything is falling into places.  I'm reshuffling patches and
testing stuff.  I'll post refreshed patchsets including IDE updates,
rq->data_len, *nr_sectors consolidation followed by peek/fetch
patchset in a few days.

Thanks.

-- 
tejun
