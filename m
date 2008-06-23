Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYFWDQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYFWDQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYFWDQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:16:05 -0400
Received: from ozlabs.org ([203.10.76.45]:40101 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbYFWDQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:16:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: kernel BUG at kernel/workqueue.c:169 (was: linux-next: Tree for June 16)
Date: Mon, 23 Jun 2008 13:15:54 +1000
User-Agent: KMail/1.9.9
Cc: rpjday@crashcourse.ca, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20080616190103.c3271e3e.sfr@canb.auug.org.au> <1213651727.3275.3.camel@dhcppc4> <1213987718.3134.7.camel@dhcppc4>
In-Reply-To: <1213987718.3134.7.camel@dhcppc4>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231315.54490.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 June 2008 04:48:37 Thomas Meyer wrote:
> I tried to bisect this one, but without a consistent result.

That's always suspicious...

> Another thing i tried is to change <linux/kernel.h>:

This will also cause almost everything to be rebuilt.  I find it hard to 
believe this is the culprit; does a "make clean" also fix it?

Thanks,
Rusty.
