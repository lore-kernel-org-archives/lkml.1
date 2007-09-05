Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbXIERdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbXIERdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbXIERdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:33:36 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:61040 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754540AbXIERdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:33:35 -0400
Date: Wed, 5 Sep 2007 20:33:32 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel 2.6.22: what IS the VM doing?
Message-ID: <20070905173332.dzwkm5ofdvtjcal4@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070830115429.w2puzet5sllhccdk@m.safari.iki.fi> <46DE085F.2040306@redhat.com> <20070905114545.2hydqpasqx56afkf@m.safari.iki.fi> <46DED83A.8070104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DED83A.8070104@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 12:24:26 -0400, Rik van Riel wrote:
...
>> *shrug*
>
> The attached patch should make sure kswapd does not free an
> excessive number of pages in zone_normal just because the
> pages in zone_highmem are difficult to free.
>
> It does give kswapd a large margin to continue putting equal
> pressure on all zones in normal situations.
>
> Sami, could you try out this patch to see if it helps your
> situation?

Thanks, Rik.  bzImage is ready, I probably reboot inside one
month for a reason or other 8-)

-- 
Do what you love because life is too short for anything else.

