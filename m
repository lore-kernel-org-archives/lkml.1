Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbYHDSWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbYHDSWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbYHDSWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:22:16 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:8843 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbYHDSWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:22:12 -0400
X-BigFish: VPS-33(zz1432R98dR1805M936fQzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <48974973.6000408@am.sony.com>
Date: Mon, 4 Aug 2008 11:24:51 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
References: <20080731092703.661994657@free-electrons.com> <20080731093220.969460336@free-electrons.com> <20080802163848.GB30454@fieldses.org> <20080804155237.1f64892d@surf> <20080804181641.GE25940@fieldses.org>
In-Reply-To: <20080804181641.GE25940@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 04 Aug 2008 18:21:57.0252 (UTC) FILETIME=[FAA4C440:01C8F65E]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Mon, Aug 04, 2008 at 03:52:37PM +0200, Thomas Petazzoni wrote:
>> Le Sat, 2 Aug 2008 12:38:48 -0400,
>> "J. Bruce Fields" <bfields@fieldses.org> a écrit :
>>
>>> Out of curiosity, why does the nfs client need disabling, but not
>>> nfsd, gfs2, fuse, etc.?
>> Then also need disabling.
> 
> OK by me, but again, why exactly?  Since you're replacing the locking
> calls they used by stubs that just return errors, in theory nfs, nfsd,
> gfs2, and the rest should still compile and run, just without locking
> support, right?

I think so, but haven't tested this myself.

However, I would still be inclined to NOT add the extra config
dependencies.  Just my 2 cents.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

