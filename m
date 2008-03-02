Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYCBPkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYCBPkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 10:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYCBPju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 10:39:50 -0500
Received: from gw.goop.org ([64.81.55.164]:54044 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYCBPjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 10:39:49 -0500
Message-ID: <47CAC931.1000107@goop.org>
Date: Sun, 02 Mar 2008 07:35:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Christopher S. Aker" <caker@theshore.net>
CC: virtualization@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Xen paravirt frontend block hang
References: <4772AC8E.7010007@theshore.net> <47C712EF.1060703@goop.org> <47C9F818.4020200@theshore.net>
In-Reply-To: <47C9F818.4020200@theshore.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher S. Aker wrote:
> Jeremy Fitzhardinge wrote:
>> I've been running this all night without seeing any problem.  I'm 
>> using current x86.git#testing with a few local patches, but nothing 
>> especially relevent-looking.
>
> Meh .. what backend are you using?  We're using LVM volumes exported 
> directly into the domUs like so:
>
> disk =[ 'phy:vg1/xencaker-56392,xvda,w', ... ]
>
>> Could you try the attached patch to see if it makes any difference?
>
> Unfortunately we're still in the same place... pv_ops kernels are 
> still hanging after heavy disk IO:
>
> works - 2.6.18.x (from xen-unstable)
> hangs - 2.6.25-rc3-git3
> hangs - 2.6.25-rc3-git3 + your patch
>
> Any other suggestions or debugging I can provide that would be useful 
> to squash this? 

Are you running an SMP or UP domain?  I found I could get hangs very 
easily with UP (but I need confirm it isn't a result of some other very 
experimental patches).

    J
