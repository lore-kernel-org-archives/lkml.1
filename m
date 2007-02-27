Return-Path: <linux-kernel-owner+w=401wt.eu-S965029AbXB0BAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029AbXB0BAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 20:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965150AbXB0BAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 20:00:42 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46427 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965029AbXB0BAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 20:00:42 -0500
Message-ID: <45E382B8.8040207@vmware.com>
Date: Mon, 26 Feb 2007 17:00:40 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC] Use para_fill instead of vmi_get_function for APIC ops
References: <45E37617.6050107@codemonkey.ws> <45E37EB5.7070100@vmware.com> <45E38032.3020704@codemonkey.ws>
In-Reply-To: <45E38032.3020704@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
>
> It would be really great if one could write a ROM by just specifying a 
> GetRelocationInfo function that always returns rel.type == NONE.  
> Right now, there are a half a dozen or so ops that have to be 
> implemented b/c of the vmi_get_function stuff.

Yes, I need to clean this up.  There are a couple other places where I 
took liberties and just did things that way because this was how our 
VMware ROM was implemented.  Just be sure, if you are going to implement 
a ROM, it has to be GPL'd now, otherwise the VMI code won't accept it.

>
>> I assume this patch is signed-off-by you?  If so, I'll add it to my 
>> patch queue.
>
> Yeah, but please make sure to test it.  I haven't at all.

It passes test level 1, which is good enough to make it into my patchset.

Zach
