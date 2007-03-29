Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbXC2HRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbXC2HRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 03:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXC2HRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 03:17:21 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:34965
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbXC2HRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 03:17:21 -0400
Message-Id: <460B843C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 29 Mar 2007 08:17:48 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [PATCH] x86: tighten kernel image page access rights
References: <4607F177.76E4.0078.0@novell.com>
 <200703282107.11511.ak@suse.de>
In-Reply-To: <200703282107.11511.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 28.03.07 21:07 >>>
>
>> +#ifdef CONFIG_HOTPLUG_CPU
>> +	/* It must still be possible to apply SMP alternatives. */
>> +	if (num_possible_cpus() <= 1)
>
>It would be better to temporarily change the pages where the alternatives
>are applied while that is done and keep it otherwise ro

I had considered that, but not done so due to the larger resulting patch.
Are you okay with doing this as a follow-up step?

Jan
