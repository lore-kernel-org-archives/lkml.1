Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYFKMIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYFKMIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYFKMIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:08:45 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:41144 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYFKMIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:08:44 -0400
To: Pavel Machek <pavel@suse.cz>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver: Setup routines
From: Andi Kleen <andi@firstfloor.org>
References: <20080609175030.2844.77365.sendpatchset@localhost.localdomain>
	<20080611105151.GE5612@ucw.cz>
Date: Wed, 11 Jun 2008 14:07:59 +0200
In-Reply-To: <20080611105151.GE5612@ucw.cz> (Pavel Machek's message of "Wed, 11 Jun 2008 12:51:51 +0200")
Message-ID: <87abhsp42o.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Jun 2008 12:00:48.0262 (UTC) FILETIME=[C95B5260:01C8CBBA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@suse.cz> writes:

> Hi!
>
>> This patchset supports the new profiling hardware available in the latest AMD CPUs in the oProfile driver.
>
>> @@ -419,9 +454,15 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>>  			break;
>>  		case 0x10:
>>  			model = &op_athlon_spec;
>> -			cpu_type = "x86-64/family10";
>> +			cpu_type = "x86-64/family10h";
>> +			break;
>
> Is this string visible to userspace?

Yes it is.

-Andi
