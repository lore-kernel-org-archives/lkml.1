Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbYBGPg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbYBGPg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYBGPgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:36:19 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:20262 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918AbYBGPgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:36:18 -0500
Message-ID: <47AB256A.5070304@msgid.tls.msk.ru>
Date: Thu, 07 Feb 2008 18:36:10 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: remount-ro & umount & quota interaction
References: <47A9F495.8060400@msgid.tls.msk.ru> <20080207102815.GB26403@atrey.karlin.mff.cuni.cz> <47AAE250.8040702@msgid.tls.msk.ru> <20080207140441.GF6140@duck.suse.cz>
In-Reply-To: <20080207140441.GF6140@duck.suse.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
[]
>> I mean, why it locks in the first place?  Quota subsystem trying
>> to write something into an read-only filesystem?  If so, WHY it
>> is trying to do that on umount instead on a remount-ro?

>   Actually, I couldn't reproduce the hang on my testing machine so I don't
> know exactly why it hangs. But my guess is that it's because we try to
> write to the filesystem...

I can't reproduce it here easily as well.  Yesterday I had a
locked-up console and had to hard-reboot the machine due to
this (it was far from first time when I've hit this issue),
but "on-demand reproducing" don't work (the uptime on that
host was about 100 days, and I had to do some repartition -
hence remount-ro to copy consistent data to other place -
maybe during that 100 day there was something... ;)

And I wasn't able to reproduce it on 2.6.24 so far, as well
(this one is only used on a test machine so far).

I'll keep trying ;)

Thanks for your support!

/mjt
