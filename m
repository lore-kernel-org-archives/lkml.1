Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbYBDHdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbYBDHdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 02:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYBDHdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 02:33:11 -0500
Received: from mx1.suse.de ([195.135.220.2]:43292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbYBDHdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 02:33:09 -0500
Message-ID: <47A6BFB1.4040504@suse.de>
Date: Mon, 04 Feb 2008 08:33:05 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch] scsi: fix spurious build failures in aic7xxx
References: <20080201225056.GA18302@elte.hu> <20080202135935.GA23838@uranus.ravnborg.org> <20080202140326.GA6544@elte.hu> <20080202140630.GA7939@elte.hu> <20080202141857.GA8635@elte.hu> <20080202162611.GA24765@uranus.ravnborg.org> <20080202171020.GB12748@elte.hu> <20080203045441.GA12128@elte.hu> <20080203074143.GA19981@uranus.ravnborg.org>
In-Reply-To: <20080203074143.GA19981@uranus.ravnborg.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Sun, Feb 03, 2008 at 05:54:41AM +0100, Ingo Molnar wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>>> I could not reproduce the bug myself but I think I spotted it. We 
>>>> had a missing dependency to the _reg.h file. Try following patch and 
>>>> let me now if it continue to break.
>>> thanks! I threw this into the test setup and will know by tomorrow 
>>> whether there's any breakage.
>> good news: hundreds of successful kernel builds and no failures 
>> overnight. I've Cc:-ed the aic7xxx people.
> 
> Thanks for testing Ingo.
> 
> James - I plan to submit this via kbuild.git in about 10 hours.
> Let me know if you would like it to go in via scsi and I
> will drop you an updated patch (need to elaboarte a bit more in
> the commit message).
> 
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
