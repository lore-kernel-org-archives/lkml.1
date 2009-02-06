Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZBFJB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZBFJB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBFJBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:01:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54630 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZBFJBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:01:18 -0500
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: marching through all physical memory in software
From: Andi Kleen <andi@firstfloor.org>
References: <497DD8E5.1040305@nortel.com>
Date: Fri, 06 Feb 2009 10:00:30 +0100
In-Reply-To: <497DD8E5.1040305@nortel.com> (Chris Friesen's message of "Mon, 26 Jan 2009 09:38:13 -0600")
Message-ID: <87bptgvt1t.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Chris Friesen" <cfriesen@nortel.com> writes:

> Someone is asking me about the feasability of "scrubbing" system
> memory by accessing each page and handling the ECC faults.

I would expect any ECC RAM capable memory controller designed 
in the last 10-15 years to be able to do this on its own without
software intervention. Is that not true? It is certainly
on x86 (although you sometimes have to change BIOS options)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
