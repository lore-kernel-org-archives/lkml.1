Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYF1FHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYF1FHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 01:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYF1FHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 01:07:25 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:13559 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYF1FHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 01:07:24 -0400
To: dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/13] EDAC i5100 new intel chipset driver
From: Andi Kleen <andi@firstfloor.org>
References: <48652da5.s2xXeJUyQ6DrqarN%dougthompson@xmission.com>
Date: Sat, 28 Jun 2008 07:07:21 +0200
In-Reply-To: <48652da5.s2xXeJUyQ6DrqarN%dougthompson@xmission.com> (dougthompson@xmission.com's message of "Fri, 27 Jun 2008 12:12:53 -0600")
Message-ID: <87r6aip2pi.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Jun 2008 05:00:01.0883 (UTC) FILETIME=[D25D5AB0:01C8D8DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dougthompson@xmission.com writes:
>
> 2)  I have not yet tackled the de-interleaving of the
> rank/controller address space into the physical address
> space of the CPU.  There is nothing fundamentally missing,
> it is just ending up to be a lot of code, and I'd rather
> keep it separate for now, esp since it doesn't work yet...
>
> 3)  The code depends on a particular i5100 chip select
> to DIMM mainboard chip select mapping.  This mapping
> seems obvious to me in order to support dual and single
> ranked memory, but it is not unique and DIMM labels
> could be wrong on other mainboards.  There is no way
> to query this mapping that I know of.

Since there's a non negligible probability that the output
of this driver is completely misleading because of (2) and (3)
and probably (4) too [reporting the wrong DIMMs etc.]
would it be possible to add some flag to EDAC that 
warns the user that the output is not fully reliable?

-Andi (who can just see people replacing the wrong DIMMs and 
then blaming Linux)

