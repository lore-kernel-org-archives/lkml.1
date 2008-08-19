Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYHSP7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYHSP7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYHSP64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:58:56 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49007 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYHSP6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:58:55 -0400
Subject: Re: [discuss] memrlimit - potential applications that can use
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrea Righi <righi.andrea@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <48AA73B5.7010302@linux.vnet.ibm.com>
References: <48AA73B5.7010302@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 08:58:44 -0700
Message-Id: <1219161525.23641.125.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 12:48 +0530, Balbir Singh wrote:
> 1. To provide a soft landing mechanism for applications that exceed their memory
> limit. Currently in the memory resource controller, we swap and on failure OOM.
> 2. To provide a mechanism similar to memory overcommit for control groups.
> Overcommit has finer accounting, we just account for virtual address space usage.
> 3. Vserver will directly be able to port over on top of memrlimit (their address
> space limitation feature)

Balbir,

This all seems like a little bit too much hand waving to me.  I don't
really see a single concrete user in the "potential applications" here.
I really don't understand why you're pushing this so hard if you don't
have anyone to actually use it.

I just don't see anyone that *needs* it.  There's a lot of "it would be
nice", but no "needs".

-- Dave

