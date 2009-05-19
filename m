Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZESL2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZESL2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZESL2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:28:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36581 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZESL2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:28:04 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org, menage@google.com
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
From: Andi Kleen <andi@firstfloor.org>
References: <20090519073942.GA10864@sli10-desk.sh.intel.com>
	<1242722454.26820.461.camel@twins>
Date: Tue, 19 May 2009 13:27:57 +0200
In-Reply-To: <1242722454.26820.461.camel@twins> (Peter Zijlstra's message of "Tue, 19 May 2009 10:40:54 +0200")
Message-ID: <8763fxpc1u.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> Furthermore, I object to being able to remove online cpus from the top
> cpuset, that just doesn't make sense.

Note you can already do it at boot time with isolated_cpus=...
So your objection seems to be a few years too late.

Shaohua's patch just makes it work at runtime too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
