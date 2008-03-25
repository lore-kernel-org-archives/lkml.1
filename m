Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbYCYBhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbYCYBhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 21:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYCYBha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 21:37:30 -0400
Received: from ns.theshore.net ([67.18.92.50]:38261 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbYCYBh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 21:37:29 -0400
Message-ID: <47E85766.7020108@theshore.net>
Date: Mon, 24 Mar 2008 21:37:42 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org, xming <xmingske@gmail.com>
Subject: Re: [Xen-devel] Re: Xen paravirt frontend block hang
References: <4772AC8E.7010007@theshore.net> <47C712EF.1060703@goop.org>	<47C9F818.4020200@theshore.net> <47CAC931.1000107@goop.org> <47CACFBE.5010007@theshore.net> <47DFE75B.7080404@goop.org>
In-Reply-To: <47DFE75B.7080404@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Christopher S. Aker wrote:
>> Jeremy Fitzhardinge wrote:
>>> Are you running an SMP or UP domain?  I found I could get hangs very 
>>> easily with UP (but I need confirm it isn't a result of some other 
>>> very experimental patches).
>>
>> The hang occurs with both SMP and UP compiled pv_ops kernels.  SMP 
>> kernels are still slightly responsive after the hang occurs, which 
>> makes me think only one proc gets stuck at a time, not the entire kernel. 
> 
> The patch I posted yesterday - "xen: fix RMW when unmasking events" - 
> should definitively fix the hanging-under-load bugs (I hope). 

Confirmed-by: caker@theshore.net

Nice work!

-Chris

