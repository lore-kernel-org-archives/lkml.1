Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbYKLNqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbYKLNqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYKLNqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:46:14 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53063 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752099AbYKLNqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:46:14 -0500
Message-ID: <491ADE21.7080707@sgi.com>
Date: Wed, 12 Nov 2008 05:46:09 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Takashi Iwai <tiwai@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allocate module.ref array dynamically
References: <s5htzaekp6o.wl%tiwai@suse.de> <491A01E2.2010701@cosmosbay.com> <200811121214.33150.rusty@rustcorp.com.au> <491A3EB9.8020203@sgi.com> <Pine.LNX.4.64.0811112115090.10592@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811112115090.10592@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 11 Nov 2008, Mike Travis wrote:
> 
>> I haven't looked closely at Christoph's latest but I believe the x86_64 version
>> is waiting for the zero-based percpu variables (and hence the combined pda/percpu
>> base.)  It's on the queue just under 4k cpus.
> 
> The base cpu_alloc is indepedent. And your laziness on the zero based
> stuff only hurts the x86_64 version. Frankly, I think we should stop
> merging 4k patches until you have finished the work on zero based because
> that is elementary for various other things and simplifies 4k work. And it
> has been pending for more than 6 months now.
> 


Trust me, I would have finished it by now, but the most critical objective for me
(and hence the direction from my mgmt) is that SGI is able to ship UV systems when
they are ready, to customers who are buying them, to perform as they are expecting.
Nothing else comes close in priority.  I've already missed two merge windows,
missing a third and I may have to learn hara-kiri. ;-)  [And working up to 7 days
of 10-14+ hours per day, is not what one would normally think of as lazy.]

Thanks,
Mike
