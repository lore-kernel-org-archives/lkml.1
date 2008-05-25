Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYEYRhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYEYRhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 13:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYEYRhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 13:37:31 -0400
Received: from main.gmane.org ([80.91.229.2]:60522 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbYEYRha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 13:37:30 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: question about splice performance
Date: Sun, 25 May 2008 18:22:50 +0100
Message-ID: <g1c84b$96v$1@ger.gmane.org>
References: <38b2ab8a0805250812l2ecd424bh74a1694ed56460de@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 87.113.14.160.plusnet.pte-ag1.dyn.plus.net
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<posted & mailed>

Francis Moreau wrote:

> Hi,
> 
> I did a really basic benchmark and was suprise about the results.
> 
> $ echo 3 > /proc/sys/vm/drop_caches
> $ time  splice-cp  vmlinux /tmp/vmlinux

Are vmlinux and /tmp both RAM filesystems? If not you may want to try
using /dev/shm to rule out disk speed...

-- 
Sitsofe | http://sucs.org/~sits/

