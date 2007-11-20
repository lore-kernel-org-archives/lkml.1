Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbXKTB3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbXKTB3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758601AbXKTBVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:21:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758596AbXKTBVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:21:42 -0500
Message-ID: <474236A0.8030601@zytor.com>
Date: Mon, 19 Nov 2007 17:21:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Stephen Clark <Stephen.Clark@seclark.us>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Power Saving
References: <47422D3B.8080704@seclark.us> <20071120005443.GB9243@redhat.com> <474232D9.20407@seclark.us> <20071120011236.GA17420@redhat.com>
In-Reply-To: <20071120011236.GA17420@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
>  > 
>  > and:
>  > cat /proc/acpi/processor/CPU0/throttling
>  > state count:             2
>  > active state:            T0
>  > states:
>  >    *T0:                  00%
>  >     T1:                  50%
> 
> See above. These are throttling states, used typically
> if the system is overheating.
> 

And more importantly, there is no power advantages over T states as 
opposed to C states.  They pretty much mean pulsing the system in and 
out of either C1 or C2 depending on the CPU/chipset.

	-hpa
