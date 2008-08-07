Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYHGQBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYHGQBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYHGQBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:01:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40319 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYHGQBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:01:05 -0400
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
From: Andi Kleen <andi@firstfloor.org>
References: <20080806090246.GA1572@elf.ucw.cz>
Date: Thu, 07 Aug 2008 18:01:02 +0200
In-Reply-To: <20080806090246.GA1572@elf.ucw.cz> (Pavel Machek's message of "Wed, 6 Aug 2008 11:02:47 +0200")
Message-ID: <87bq046cht.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@suse.cz> writes:

> Hi!
>
> Aug  6 11:00:10 amd kernel: ACPI: Critical trip point
> Aug  6 11:00:10 amd kernel: Critical temperature reached (128 C),
> shutting down.
> Aug  6 11:00:10 amd shutdown[24414]: shutting down for system halt
>
> ...and machine went down at that point :-(.

I hope you can easily reproduce it?

So it's new in 2.6.27rc1 and wasn't in 2.6.26? Can you please
double check that? Are there are new warnings in the boot logs
from ACPI compared to .26?

I looked through the pile of patches that went in for ACPI and the 
only candidate that might have imho caused this would be 
ea51011a27db48ea0a80a5e20de3969b292d5d4d. Can you please 
try reverting that. If that doesn't help a full bisect will be needed.

-Andi
