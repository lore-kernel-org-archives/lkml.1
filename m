Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbZEMKjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbZEMKjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZEMKjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:39:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:37490 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbZEMKjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:39:00 -0400
From: Neil Brown <neilb@suse.de>
To: roma1390 <roma1390@gmail.com>
Date: Wed, 13 May 2009 20:39:20 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18954.41816.775504.802570@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: md: Can't convert raid level
In-Reply-To: message from roma1390 on Wednesday May 13
References: <4A0A82D5.6000704@gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday May 13, roma1390@gmail.com wrote:
> Hello,
> 
> tested with linux-2.6.git a4f1cb9f3c42e5d278b0678ed5225d9331a8dcff
> 
> If i have spare disk i can grow
> raid1, raid4, raid5 and raid6
> 
> but can't convert to other raid level. Raid conversation matrix:
> 
> from\to | 0 | 1 | 4 | 5 | 6
> ============================
>   raid0  | -   -   -   -   -
>   raid1  | -   +   -   -   -
>   raid4  |-22 -22  +  -22 -22
>   raid5  |-22 -22 -22  +  -22
>   raid6  |-22 -22 -22 -22  +
> 
> Sample test script, log, dmesg, kernel config is attached.
> 
> Major problem is than can not do online covert from raid5 to raid6:

Correct.  This functionality has not been implemented yet.

The kernel contains the required support, but mdadm does not make use
of it correctly yet.

NeilBrown
