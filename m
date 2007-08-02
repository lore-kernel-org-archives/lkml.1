Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbXHBQgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbXHBQgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbXHBQgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:36:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:54896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbXHBQgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:36:19 -0400
From: Andreas Schwab <schwab@suse.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: <trenn@suse.de>, "Adrian Bunk" <bunk@stusta.de>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Jan Dittmer" <jdi@l4x.org>,
       "Len Brown" <lenb@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>
Subject: Re: scripts/mod/file2alias.c cross compile problem
References: <617E1C2C70743745A92448908E030B2A0211AFF0@scsmsx411.amr.corp.intel.com>
X-Yow: ...A housewife is wearing a polypyrene jumpsuit!!
Date: Thu, 02 Aug 2007 18:36:14 +0200
In-Reply-To: <617E1C2C70743745A92448908E030B2A0211AFF0@scsmsx411.amr.corp.intel.com>
	(Tony Luck's message of "Thu\, 2 Aug 2007 09\:25\:58 -0700")
Message-ID: <jewswdvqpt.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Luck, Tony" <tony.luck@intel.com> writes:

>> +#define FILLUP_LEN	7 /* dirty fix for i386 -> 64bit cross-compilation */
>>  
>>  struct acpi_device_id {
>>  	__u8 id[ACPI_ID_LEN];
>> +	__u8 dummy[FILLUP_LEN];
>>  	kernel_ulong_t driver_data;
>>  };
>
> What's so special about this structure that we get an error?

It's special because it's a device_id structure, and those structures
must come out identical using either the host or the target compiler.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
