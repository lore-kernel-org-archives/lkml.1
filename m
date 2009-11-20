Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbZKTRTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbZKTRTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZKTRTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:19:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbZKTRTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:19:44 -0500
Message-ID: <4B06CE40.3060903@zytor.com>
Date: Fri, 20 Nov 2009 09:13:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>, Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>, jakub@redhat.com,
       gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC
 messing with mcount prologue
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>	 <20091119072040.GA23579@elte.hu>	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>	 <1258694593.22249.1012.camel@gandalf.stny.rr.com> <1258736456.22249.1032.camel@gandalf.stny.rr.com>
In-Reply-To: <1258736456.22249.1032.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2009 09:00 AM, Steven Rostedt wrote:
> Ingo, Thomas and Linus,
> 
> I know Thomas did a patch to force the -mtune=generic, but just in case
> gcc decides to do something crazy again, this patch will catch it.
> 
> Should we try to get this in now?
> 

Sounds like a very good idea to me.
	
	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

