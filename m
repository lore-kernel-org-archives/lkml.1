Return-Path: <linux-kernel-owner+w=401wt.eu-S934647AbXHVWZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647AbXHVWZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764148AbXHVWZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:25:45 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:4438 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764145AbXHVWZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:25:44 -0400
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 18:25:44 EDT
Message-ID: <46CCB56F.8090308@superbug.co.uk>
Date: Wed, 22 Aug 2007 23:15:11 +0100
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20070804)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zach@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <46CCB088.8070606@goop.org>
In-Reply-To: <46CCB088.8070606@goop.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>> This patch provides hypercalls for the i386 port I/O instructions,
>> which vastly helps guests which use native-style drivers.  For certain
>> VMI workloads, this provides a performance boost of up to 30%.  We
>> expect KVM and lguest to be able to achieve similar gains on I/O
>> intensive workloads.
> 
> Two comments:
> 
> - I should dust off my "break up paravirt_ops" patch, and this would fit
> nicely into it (I think we already discussed this)
> 
> - What happens if you *don't* want to pv some of the io instructions? 
> What if you have a device which is directly exposed to the guest?


If one could directly expose a device to the guest, this feature could
be extremely useful for me.
Is it possible? How would it manage to handle the DMA bus mastering?

James
