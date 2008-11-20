Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbYKTRH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbYKTRH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYKTRHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:07:47 -0500
Received: from gw.goop.org ([64.81.55.164]:53000 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbYKTRHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:07:47 -0500
Message-ID: <49259961.1030309@goop.org>
Date: Thu, 20 Nov 2008 09:07:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
References: <patchbomb.1226603398@abulafia.goop.org> <d103c0da2fa147ac31af.1226603428@abulafia.goop.org> <20081120083329.GA13996@verge.net.au>
In-Reply-To: <20081120083329.GA13996@verge.net.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman wrote:
> Hi,
>
> it seems that if CONFIG_XEN is set by CONFIG_XEN_DOM0 is not set,
> then the call to xen_init_apic() in xen_start_kernel() causes the
> build to fail.
>
> One possible soluion to this is to provide a dummy
> version of xen_init_apic() in the !CONFIG_XEN_DOM0 case.
>
> Another possible solution would be to add #ifdef CONFIG_XEN_DOM0
> inside xen_start_kernel()
>   

Ah, OK, will fix that up.

    J
