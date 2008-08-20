Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYHTB7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYHTB7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYHTB7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:59:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40269 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYHTB7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:59:42 -0400
Date: Wed, 20 Aug 2008 04:01:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, oleg@tv-sign.ru,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: tracehook breaks dhcpcd child processing
Message-ID: <20080820020133.GP9807@one.firstfloor.org>
References: <20080819155722.GA25695@basil.nowhere.org> <20080819194318.8572815426B@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819194318.8572815426B@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 12:43:18PM -0700, Roland McGrath wrote:
> Thanks for the report.
> 
> Was this problem after the fixes in:
> commit 5861bbfcc10fc0358abf52c7d22850c8d180f0b0
> commit 5c7edcd7ee6b77b88252fe4096dce1a46a60c829
> ?

Yes. I saw it with yesterday's Linus HEAD

> 
> Do you know the process-level details that cause the problem?
> (i.e. exits with what parent/signals/etc conditions)
> It may take me a bit to set up an opensuse 11.0 vm to try its dhcpcd.

Not currently. I'll send you a strace log later.

-Andi
