Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXFEVQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXFEVQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765849AbXFEVP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:15:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49463 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765839AbXFEVP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:15:57 -0400
Message-ID: <4665D270.2020301@zytor.com>
Date: Tue, 05 Jun 2007 14:15:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lguest-fix-divide-error-implement-sched_clock
References: <20070522223828.GV11115@waste.org> <20070605090714.22bfcfd4.akpm@linux-foundation.org> <46658C41.9090105@zytor.com> <200706051837.22847.ak@suse.de>
In-Reply-To: <200706051837.22847.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> I don't think it's a good idea for the TSC. There are various
> setups where it is unreliable and also often simulators don't 
> implement it correctly. And it's always a valuable workaround
> to be able to turn it off.
> 

For all I can tell, if this is the case, then CONFIG_X86_TSC should be
removed completely.  We still support the TSC when CONFIG_X86_TSC is not
compiled in; that attribute controls if it is unconditionally required.

(We seem to still not always use it, which may be a good indication that
CONFIG_X86_TSC has outlived its usefulness.  Should it be removed?)

	-hpa
