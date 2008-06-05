Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbYFESBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbYFESBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYFESA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:00:56 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42735 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYFESAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:00:55 -0400
Date: Thu, 5 Jun 2008 21:00:53 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, mcmanus@ducksong.com,
       peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, rjw@sisk.pl,
       Andrew Morton <akpm@linux-foundation.org>, johnpol@2ka.mipt.ru
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
 v2.6.26-rc3+
In-Reply-To: <20080605142244.GA19216@elte.hu>
Message-ID: <Pine.LNX.4.64.0806052059380.31672@wrl-59.cs.helsinki.fi>
References: <20080603094057.GA29480@elte.hu> <Pine.LNX.4.64.0806032245490.3474@wrl-59.cs.helsinki.fi>
 <Pine.LNX.4.64.0806040052270.3474@wrl-59.cs.helsinki.fi>
 <20080603.150344.145518113.davem@davemloft.net>
 <Pine.LNX.4.64.0806040208350.7315@wrl-59.cs.helsinki.fi> <20080605142244.GA19216@elte.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-650765930-1212688853=:31672"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-650765930-1212688853=:31672
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 5 Jun 2008, Ingo Molnar wrote:

> 
> * Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
> 
> > [PATCH] tcp DEFER_ACCEPT: fix racy access to listen_sk
> 
> i unapplied the reverts then applied your fix, and got this hang after 
> 1.5 hours of testing:
> 
>  titan:~> netstat -nt
>  Active Internet connections (w/o servers)
>  Proto Recv-Q Send-Q Local Address           Foreign Address   State
>  tcp        0  65032 10.0.1.14:39454         10.0.1.19:3632    ESTABLISHED
> 
> 10.0.1.14 is this box, Core2Duo dual-core. 10.0.1.19 is another box with 
> 16 CPUs.

Did 10.0.1.19 too have the fix (the receiving end is the important 
one to have this fix)?

-- 
 i.
---696208474-650765930-1212688853=:31672--
