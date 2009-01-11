Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZAKFou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZAKFou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 00:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbZAKFof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 00:44:35 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54092 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbZAKFoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 00:44:34 -0500
Message-ID: <49698739.6010003@garzik.org>
Date: Sun, 11 Jan 2009 00:44:25 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
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

Oh, I forgot to reply to this...  libata-2.6.git#hibern_regress no 
longer applies cleanly.

I'll try poking at it on Monday and get it cleaned up, as it is IMO a 
bug fix and still should go in.

	Jeff



