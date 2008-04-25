Return-Path: <linux-kernel-owner+w=401wt.eu-S1763517AbYDYQda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763517AbYDYQda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760265AbYDYQdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:33:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39845 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759366AbYDYQdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:33:21 -0400
Date: Fri, 25 Apr 2008 09:37:36 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, oliver@neukum.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, zaitcev@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] klist: implement KLIST_INIT() and DEFINE_KLIST()
Message-ID: <20080425163736.GC10397@kroah.com>
References: <480DB6A4.20101@gmail.com> <1208869049.7115.254.camel@twins> <480DE215.2070803@gmail.com> <1208869591.7115.263.camel@twins> <480DE3B3.6050702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480DE3B3.6050702@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 10:10:11PM +0900, Tejun Heo wrote:
> Peter Zijlstra wrote:
>>> These locks don't nest so being in the same class should be okay and I 
>>> was following what (at least some of) other __SPIN_LOCK_UNLOCKED users 
>>> are doing.  If putting these locks into separate classes is the RTTD, 
>>> sure.
>> Ah, they'll actually be in seprate classes all of the same name. So I
>> think it is cleaner to cause them to have separate names too.
>> see look_up_lock_class() in kernel/lockdep.c:
>>         /*
>>          * Static locks do not have their class-keys yet - for them the 
>> key
>>          * is the lock object itself:
>>          */
>>         if (unlikely(!lock->key))
>>                 lock->key = (void *)lock;
>
> Ah.. I'll put change it to name.  Thanks.

Do you have a new revision of this patch series that I can apply to my
trees?

thanks,

greg k-h
