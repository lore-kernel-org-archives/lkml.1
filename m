Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYLDKCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYLDKCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYLDKCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:02:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52123 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbYLDKCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:02:37 -0500
Date: Thu, 4 Dec 2008 11:13:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.28-rc6: early panic with boot option "nosmp"
Message-ID: <20081204101343.GO6703@one.firstfloor.org>
References: <20081204022806.GA29293@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204022806.GA29293@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 10:28:06AM +0800, Wu Fengguang wrote:
> Hi,
> 
> The boot option "maxcpus=0" or "nosmp" makes kernel 2.6.28-rc6 panic
> immediately after booting:
> 
> PANIC: early exception 0e rip 10:ffffffff8176d6ff error 0 cr2 9

It would be useful if you could look the ffffffff8176d6ff 
address up in your System.map or using gdb.

-Andi
