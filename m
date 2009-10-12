Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZJLJht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZJLJht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZJLJht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:37:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52395
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404AbZJLJhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:37:48 -0400
Date: Mon, 12 Oct 2009 02:37:44 -0700 (PDT)
Message-Id: <20091012.023744.157085851.davem@davemloft.net>
To: linux@arm.linux.org.uk
Cc: ngupta@vflare.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] force dcache flush if dcache_dirty bit set
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091012090710.GA29310@n2100.arm.linux.org.uk>
References: <1255337423-3158-1-git-send-email-ngupta@vflare.org>
	<20091012090710.GA29310@n2100.arm.linux.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Mon, 12 Oct 2009 10:07:10 +0100

> On Mon, Oct 12, 2009 at 02:20:23PM +0530, Nitin Gupta wrote:
>> Same problem exists on mips too.
> 
> Nice catch.  This logic came from sparc64, so I think you'd want to talk
> to davem about it as well.
> 
> In the mean time, submitting your fix to the patch system would be great,
> thanks.

Sparc64 flushes unconditionally when there is no page mapping.
So, it should be fine here.
