Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbXLIGxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbXLIGxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 01:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXLIGxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 01:53:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:48061 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXLIGxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 01:53:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=L8645lAXmlx05DZ/9f8BKJSx4C055LLJSEHBVY17ELKO82LJINFDjLeZiMd1A7YAA+r5g4Q0hLxDOQGWqlXCrtZLGUC6qhi8noJ+7vMGtE+4sqe7iitAQ8FhE5iTN0ImJngh9RnaBE0D+LL3rEX9IvsFARFN017w4TP8v5vJbaI=
Message-ID: <475B90C7.4070505@gmail.com>
Date: Sun, 09 Dec 2007 15:52:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
References: <200712080340.49546.rjw@sisk.pl> <20071208013631.3147986a.akpm@linux-foundation.org>
In-Reply-To: <20071208013631.3147986a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
>> Subject		: PATA scan: ACPI Exception AE_AML_PACKAGE_LIMIT... is beyond end of object
>> Submitter	: Hans de Bruin <bruinjm@xs4all.nl>
>> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9320
>> Handled-By	: Robert Moore <Robert.Moore@intel.com>
>> 		  Tejun Heo <htejun@gmail.com>
>> 		  Fu Michael <michael.fu@intel.com>
>> Patch		: 
>>
> 
> A number of other people are seeing the same thing and Tejun is
> putting in a blacklist of machines which cannot use libata+acpi.
> That patch is not yet in any git tree which I pull.
> 
> AFACIT the machines kepe working OK - there's just some nasty dmesg
> spew.
> 
> If any machines _are_ breaking then this could cause real problems
> and I'd prefer that we either go for a whitelist or arrange to
> detect the condition and fall back to non-acpi ata.

The pending patchset should make ATA ACPI quite resistant to failures.
Known bad boards can be blacklisted (currently only one is on the
list), ATA ACPI is disabled quicker if ACPI evalution fails, execution
errors are handled better and commands which are intended to help the
vendor instead of the user are filtered.  So, I think we have enough
safety nets.

Thanks.

-- 
tejun
