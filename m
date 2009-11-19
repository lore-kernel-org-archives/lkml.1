Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbZKSWm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbZKSWm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 17:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbZKSWm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 17:42:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57249 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbZKSWm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 17:42:56 -0500
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jeff Law <law@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney@caviumnetworks.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
In-Reply-To: <4B05B7AD.20500@redhat.com>
References: <viy9pk4xossnb6m2v041qu00.1258665258503@email.android.com>
	 <4B05B7AD.20500@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 19 Nov 2009 17:43:00 -0500
Message-Id: <1258670580.22249.1002.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 14:25 -0700, Jeff Law wrote:

> Having said all that, I don't expect to personally be looking at the 
> problem, given the list of other codegen issues that need to be looked 
> at (reload in particular), profiling/stack interactions would be around 
> 87 millionth on my list.

Is there someone else that can look at it?

Or at the very least, could you point us to where that code is, and one
of us tracing folks could take a crack at switching hats to be a
compiler writer (with the obvious prerequisite of drinking a lot of beer
first, or is there a better drug to cope with the pain of writing gcc?).

-- Steve
 

