Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbZJTTJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbZJTTJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZJTTJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:09:19 -0400
Received: from relay1.sgi.com ([192.48.179.29]:52942 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752081AbZJTTJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:09:19 -0400
Date: Tue, 20 Oct 2009 14:09:21 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robin Holt <holt@sgi.com>, tglx@linutronix.de,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Martin Hicks <mort@sgi.com>
Subject: Re: [patch 1/1] x86, UV: uv_hub_send_ipi Needs to set
	DELIVERY_MODE=4 for vector=NMI_VECTOR.
Message-ID: <20091020190921.GT8934@sgi.com>
References: <20091019091854.696198000@alcatraz.americas.sgi.com> <20091019091919.050247000@alcatraz.americas.sgi.com> <20091019130821.GC9030@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019130821.GC9030@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 03:08:21PM +0200, Ingo Molnar wrote:
> Hm, would be cleaner to create an enum for that '4' (and for 0) in 
> uv_mmrs.h and use it here. (We have similar constants for delivery modes 
> in io_apic.h, see dest_*.)

I will send another patch shortly.  This register has delivery modes
modeled after the io_apic.

Robin
