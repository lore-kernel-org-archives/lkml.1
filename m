Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZCMNE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZCMNE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZCMNEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:04:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49993 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758906AbZCMNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:04:15 -0400
Subject: Re: [PATCH] perfcounters: Make s/w counters in a group only count
 when group is on
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1236948283.22447.36.camel@twins>
References: <18873.48668.562126.113618@cargo.ozlabs.ibm.com>
	 <1236939816.22914.3714.camel@twins>
	 <18874.20538.785519.824803@cargo.ozlabs.ibm.com>
	 <1236948283.22447.36.camel@twins>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 14:04:00 +0100
Message-Id: <1236949440.5188.709.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 13:44 +0100, Peter Zijlstra wrote:

> The same for task migration, most migrations happen when they are in
> fact running, so there too we can account the migration either before we
> rip it off the src cpu, or after we place it on the dst cpu.

Right, I got confused between being on the cpu and having ->state = R.

Migrations are the odd one out indeed, but I'd rather fudge a little
with the migration counter itself than have this weird asymmetry.

