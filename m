Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYB1JZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYB1JZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 04:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYB1JZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 04:25:35 -0500
Received: from igraine.blacknight.ie ([81.17.252.25]:59265 "EHLO
	igraine.blacknight.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbYB1JZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:25:34 -0500
Date: Thu, 28 Feb 2008 09:25:12 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: Robert Fitzsimons <robfitz@273k.net>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bttv: Re-enabling radio support requires the use of
	struct bttv_fh.
Message-ID: <20080228092512.GC2662@localhost>
References: <200802171036.19619.bonganilinux@mweb.co.za> <20080227014238.GA2685@localhost> <20080227014729.GC2685@localhost> <200802272345.43209.bonganilinux@mweb.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802272345.43209.bonganilinux@mweb.co.za>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-blacknight-igraine-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 1JUf0o-0007ac-03
X-blacknight-igraine-MailScanner: Found to be clean
X-blacknight-igraine-MailScanner-SpamCheck: not spam,
	SpamAssassin (not cached, score=2.725, required 7,
	autolearn=disabled, HELO_LOCALHOST 4.50, RCVD_IN_NERDS_IE -3.50,
	RCVD_IN_PBL 0.51, RCVD_IN_SORBS_WEB 1.12, RDNS_NONE 0.10)
X-blacknight-igraine-MailScanner-SpamScore: ss
X-MailScanner-From: robfitz@273k.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have applied both your patches and my radio works, but my TV doesn't work 
> anymore (no picture or sound). But when I exit the radio program I get this 
> oops:

I've had a quick look and nothing stands out as the cause of the oops,
but I did notice that I introduced a small memory leak.  Over the next
day or so I'll have a look at Mauro's suggestion of combining the opens
like the cx88 driver.

Robert

