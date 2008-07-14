Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbYGNGEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbYGNGEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 02:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYGNGEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 02:04:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:42206 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYGNGEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 02:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=gQhNG/EVL0iobdVKMUBs/ODWUBg5k5OuBh/eTIzgo/7VlOArhQqfrnnkhgsJosb1Zl
         2hga4sZGZtdBJRf95NMgU/K1L2cRzo0Q5tpw6jy43OgLxuwb5Av8BhTrvPOzKkjVFnag
         mBIQNFnyk0GNJXG51+HU8Y34Psdvfr+InK9DM=
Date: Mon, 14 Jul 2008 06:09:33 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: 26-rc9-mmotm lockdep warning initializing loopback interface
Message-ID: <20080714060933.GA4034@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080713210755.ed9257aa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-07-2008 06:07, Andrew Morton wrote:
> On Sun, 13 Jul 2008 06:00:03 -0400 Valdis.Kletnieks@vt.edu wrote:
...
>> Found this in the dmesg:
>>
>> [    0.418581] system 00:0b: iomem range 0xfed00000-0xfed003ff has been reserved
>> [    0.421109]
>> [    0.421110] =============================================
>> [    0.421123] [ INFO: possible recursive locking detected ]
>> [    0.421132] 2.6.26-rc9-mm1 #2
>> [    0.421138] ---------------------------------------------
>> [    0.421147] swapper/1 is trying to acquire lock:
>> [    0.421154]  (&queue->lock){-...}, at: [<ffffffff804b81d5>] qdisc_lock_tree+0x27/0x2c
>> [    0.421176]
>> [    0.421177] but task is already holding lock:
>> [    0.421186]  (&queue->lock){-...}, at: [<ffffffff804b81cd>] qdisc_lock_tree+0x1f/0x2c
...
> (otoh, many of these problems are also in linux-next.  Who's testing
> that?  Hopefully it's a weekend*summer thing.)

http://permalink.gmane.org/gmane.linux.kernel.next/1514

Jarek P.

PS: it's only about lockdep annotation, and could be fixed with
other way finally.
