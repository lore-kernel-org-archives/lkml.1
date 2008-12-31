Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYLaOTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYLaOTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 09:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYLaOTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 09:19:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58882 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYLaOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 09:19:34 -0500
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 01/15] ACPI: create kernel/acpi/
From: Andi Kleen <andi@firstfloor.org>
References: <1230720725-9376-1-git-send-email-lenb@kernel.org>
	<526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
	<20081231133901.GB2388@uranus.ravnborg.org>
Date: Wed, 31 Dec 2008 15:21:08 +0100
In-Reply-To: <20081231133901.GB2388@uranus.ravnborg.org> (Sam Ravnborg's message of "Wed, 31 Dec 2008 14:39:01 +0100")
Message-ID: <87bpusv31n.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:
> Why is ACPI_CFLAGS exported?
>> +ACPI_CFLAGS	:= -Os
>> +
>> +ifdef CONFIG_ACPI_DEBUG
>> +  ACPI_CFLAGS	+= -DACPI_DEBUG_OUTPUT
>> +endif
>> +
>> +EXTRA_CFLAGS	+= $(ACPI_CFLAGS)
> A better way:
>
> ccflags-$(CONFIG_ACPI_DEBUG) := -DACPI_DEBUG_OUTPUT

Surely s/:=/+=/ ?

-Andi

-- 
ak@linux.intel.com
