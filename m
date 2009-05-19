Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZESMB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZESMB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZESMBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:01:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZESMBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:01:19 -0400
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org, menage@google.com
In-Reply-To: <8763fxpc1u.fsf@basil.nowhere.org>
References: <20090519073942.GA10864@sli10-desk.sh.intel.com>
	 <1242722454.26820.461.camel@twins>  <8763fxpc1u.fsf@basil.nowhere.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 19 May 2009 14:01:18 +0200
Message-Id: <1242734478.26820.502.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 13:27 +0200, Andi Kleen wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> >
> > Furthermore, I object to being able to remove online cpus from the top
> > cpuset, that just doesn't make sense.
> 
> Note you can already do it at boot time with isolated_cpus=...
> So your objection seems to be a few years too late.
> 
> Shaohua's patch just makes it work at runtime too.

No it doesn't. And isolcpus should die.
