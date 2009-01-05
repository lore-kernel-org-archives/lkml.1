Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbZAEIeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbZAEIeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 03:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZAEIee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 03:34:34 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42372 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbZAEIee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 03:34:34 -0500
Message-ID: <4961C60E.9030506@garzik.org>
Date: Mon, 05 Jan 2009 03:34:22 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <20081104062734.GA4420@havoc.gtf.org> <495D7DC9.8070101@kernel.org>
In-Reply-To: <495D7DC9.8070101@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Jeff Garzik wrote:
>> This adds code at a late stage (heading towards -rc4), but does
>> eliminate a particular spin-up overcycling behavior associated with
>> hibernation.
>>
>> Rafael's extended description below...  Separated to make it easier to
>> pull-or-not, separate from the other libata fixes.  There shouldn't be
>> any merge trouble between the two.
>>
>> SATA: Blacklist systems that spin off disks during ACPI power off
> 
> Jeff, I think this should be merged into 2.6.29 unless Linus still
> objects.  Linus, as discussed in this thread, this is workaround for a
> hardware / firmware problem and vanilla windows also suffers the
> problem, so as ugly as it is, we need this to prevent double spin down
> on the machine.

(Just returned from New Year's holiday)

Yes, I definitely want to put it in as well.

	Jeff



