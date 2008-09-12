Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYILPh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYILPh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYILPhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:37:17 -0400
Received: from mga10.intel.com ([192.55.52.92]:38546 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752150AbYILPhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:37:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,390,1217833200"; 
   d="scan'208";a="379581198"
Message-ID: <48CA8CAA.1000004@linux.intel.com>
Date: Fri, 12 Sep 2008 17:37:14 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Milan Broz <mbroz@redhat.com>
Subject: Re: [patch 00/42] 2.6.26-stable review
References: <20080903172447.GA7731@suse.de> <20080904023905.GA1071@khazad-dum.debian.net> <20080912142251.GA6028@ucw.cz>
In-Reply-To: <20080912142251.GA6028@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Wed 2008-09-03 23:39:05, Henrique de Moraes Holschuh wrote:
>> What about this one:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f497bcc695fb828da023d74ad3c966b1e58ad21
>>
>> "ACPI: Fix thermal shutdowns" ?
>>
>> It should have been submitted to stable@k.o well before 2.6.26.3, but it
>> wasn't for some stupid reason.  Then some of us noticed it was missing in
>> 2.6.26.3, and gave everyone a head's up, but it was too late for 2.6.26.3.
>>
>> And now it also apparently failed to make it to 2.6.26.4?
>>
>> As far as I recall, without this patch, all X6* ThinkPads that are not in
>> absolute top-notch thermal condition heat up until they are forced to
>> shutdown due to overtemperature (thus, slowly further damaging hardware that
>> is not in good shape to begin with).
>>
>> Greg, is there any way to include the above patch for 2.6.26.4?
> 
> 
> 
> Agreed. This patch makes thinkpads unusable... and it was actually
> included in 2.6.26.2...

I guess the best/safest course right now is to just revert in stable.

-Andi
