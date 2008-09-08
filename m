Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbYIHPrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYIHPrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYIHPqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:46:52 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4919 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbYIHPqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:46:51 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2008 11:46:51 EDT
Message-ID: <48C546B2.50108@xs4all.nl>
Date: Mon, 08 Sep 2008 17:37:22 +0200
From: Rambaldi <rambaldi@xs4all.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080815)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc5 xen balloon driver warnings
References: <48C0F09C.1000101@xs4all.nl> <48C457DC.9050904@goop.org>
In-Reply-To: <48C457DC.9050904@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Rambaldi wrote:
>> Hi,
>>
>> when running the 2.6.27-rc5 kernel as 64 bits dumU I get the following
>> warnings:
> 
> This patch, change 167e6cf62979df03513898966f9227847d192327 in tip.git,
> should fix this.  I'm not sure if the other sysfs changes apply to
> mainline git or not.
> 
> Could you try this and see how it goes?  The first chunk should be
> sufficient to fix your problem.
> 
>      J
> 
>

Hi Jeremy,

I used the complete patch, I had some compile warnings.
The oops is gone and I was able to access the
	/sys/devices/system/xen_memory/xen_memory0/info/current_kb
entry.

thanks,

R.

