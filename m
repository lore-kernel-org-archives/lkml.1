Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbZABVyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbZABVyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbZABVyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:54:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47377 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZABVyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:54:45 -0500
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [incremental-PATCH-for-Sam's-Review] ACPI: use ccflags-y instead of EXTRA_CFLAGS
From: Andi Kleen <andi@firstfloor.org>
References: <1230720725-9376-1-git-send-email-lenb@kernel.org>
	<526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
	<20081231133901.GB2388@uranus.ravnborg.org>
	<87bpusv31n.fsf@basil.nowhere.org>
	<20081231153441.GA3475@uranus.ravnborg.org>
	<alpine.LFD.2.00.0901021636050.3590@localhost.localdomain>
	<20090102215208.GA8494@uranus.ravnborg.org>
Date: Fri, 02 Jan 2009 22:56:15 +0100
In-Reply-To: <20090102215208.GA8494@uranus.ravnborg.org> (Sam Ravnborg's message of "Fri, 2 Jan 2009 22:52:08 +0100")
Message-ID: <87iqoxjrsw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:
>
> The conversion from ACPI_CFLAGS to ccflags-y is fine.
> And if acpi really require -Os then this part is also OK -
> I just did not get *why* acpi needs -Os

None of ACPI is performance critical and it's rather large, so it was
defaulted to -Os long before the rest of the kernel. It's not
a hard requirement, but a generally good idea.

-Andi

-- 
ak@linux.intel.com
