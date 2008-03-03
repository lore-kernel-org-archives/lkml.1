Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbYCCMTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbYCCMTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYCCMTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:19:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:52907 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYCCMTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:19:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ARgdJ/OFiocLS/7FBOsCVqT45KcnghUA+8aWaYj3BT4wACisyvDpM16ZSvJT6gTNxbQL1ZssgpQ1iHtae8VnCzCH2UT97rsY5PZPtxYx6pXs5u3sIdaIxekRaDIF3dwJ2MCq4HmpPo5+OxXLkkZOXdVqB+pbG/btQk9Dn9sWKxc=
Message-ID: <47CBECB8.7040605@gmail.com>
Date: Mon, 03 Mar 2008 13:19:04 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>, peifferp@gmail.com
Subject: Re: [BUG] soft lockup detected with ipcs
References: <47C7E280.4010805@gmail.com> <Pine.LNX.4.64.0802291241080.7699@twin.jikos.cz> <47CAE7D5.5040907@gmail.com> <20080302120236.61e0ec74.akpm@linux-foundation.org> <Pine.LNX.4.64.0803022214190.15209@jikos.suse.cz> <Pine.LNX.4.64.0803022223360.15209@jikos.suse.cz> <47CBE871.4090309@gmail.com> <Pine.LNX.4.64.0803031305090.15209@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0803031305090.15209@jikos.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 3 Mar 2008, Jiri Olsa wrote:
> 
>> I'll try the patch, so far I attached the ipcs strace and adjacent kernel logs.
> 
> Thanks for the strace.
> 
> The kernel oopses showing the soft lockup happen at the time of the first 
> segfaulting run of ipcs, or the second one that hangs?
> 
> The oopses are different compared to the ones you posted previously -- 
> those were clearly poiting to use-after-free, these show spinlock lockup.
> 

ipcs.kernel.out.1 is the kernel log from the time strace ipcs was done.
ipcs.kernel.out.2 is from the next run of ipcs that stuck,
there's no overlay between those logs.

When the kernel freeze I'm getting logs with the spinlock lockup.. and it's repeating.
