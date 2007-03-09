Return-Path: <linux-kernel-owner+w=401wt.eu-S1767196AbXCILUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767196AbXCILUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767174AbXCILUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:20:50 -0500
Received: from holomorphy.com ([66.93.40.71]:48177 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767196AbXCILUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:20:49 -0500
Date: Fri, 9 Mar 2007 03:20:18 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: David Miller <davem@davemloft.net>
Cc: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org, mbligh@google.com,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Fix sparc TIF_USEDFPU flag atomicity
Message-ID: <20070309112018.GB2994@holomorphy.com>
References: <20070309031227.GC9462@Krystal> <20070308.212523.45514581.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308.212523.45514581.davem@davemloft.net>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007 22:12:27 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
>> Fix sparc TIF_USEDFPU flag atomicity
>> Non atomic update of TIF can be very dangerous, except at thread structure
>> creation time. Here I standardize the TIF_USEDFPU usage of the sparc arch.
>> Applies on 2.6.20.
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

On Thu, Mar 08, 2007 at 09:25:23PM -0800, David Miller wrote:
> Also applied, thanks a lot.

Thanks again for doing just about everything here while I get my act
back together (never mind how preposterously long it's taking).

Acked-by: William Irwin <wli@holomorphy.com>


-- wli
