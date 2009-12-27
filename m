Return-Path: <linux-kernel-owner+w=401wt.eu-S1751483AbZL0JQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbZL0JQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 04:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZL0JQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 04:16:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbZL0JQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 04:16:46 -0500
Message-ID: <4B3725CE.8040004@redhat.com>
Date: Sun, 27 Dec 2009 11:15:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, netdev@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Alacrityvm-devel] [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org>	 <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com>	 <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu>	 <20091223101340.GC20539@basil.fritz.box> <4B31EF65.6070000@redhat.com>	 <4B325E33.8060407@gmail.com> <4B327B90.2050403@redhat.com> <b233dd490912231321p5e09946at5ea63cb0d0fa1489@mail.gmail.com>
In-Reply-To: <b233dd490912231321p5e09946at5ea63cb0d0fa1489@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 11:21 PM, Gregory Haskins wrote:
> That said, you are still incorrect.  With what I proposed, the model
> will run as an in-kernel vbus device, and no longer run in userspace.
> It would therefore improve virtio-net as I stated, much in the same
> way vhost-net or venet-tap do today.
>    

That can't work.  virtio-net has its own ABI on top of virtio, for 
example it prepends a header for TSO information.  Maybe if you disable 
all features it becomes compatible with venet, but that cripples it.

-- 
error compiling committee.c: too many arguments to function

