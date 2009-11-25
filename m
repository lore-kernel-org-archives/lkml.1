Return-Path: <linux-kernel-owner+w=401wt.eu-S934951AbZKYULE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934951AbZKYULE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934910AbZKYULD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:11:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51287 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934838AbZKYULC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:11:02 -0500
Message-ID: <4B0D8E0D.9070501@zytor.com>
Date: Wed, 25 Nov 2009 12:05:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Andrew Haley <aph@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H.J. Lu" <hjl.tools@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, gcc <gcc@gcc.gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC
 messing with mcount prologue
References: <1258694593.22249.1012.camel@gandalf.stny.rr.com>	 <1258736456.22249.1032.camel@gandalf.stny.rr.com>	 <4B06EF6F.2050507@redhat.com>	 <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com>	 <4B0972C9.302@redhat.com>	 <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com>	 <4B0BF119.4070704@redhat.com>	 <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain>	 <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com>	 <4B0BFC84.7070806@redhat.com>	 <20091124153634.GK22813@hs20-bc2-1.build.redhat.com>	 <4B0BFFD0.2080203@redhat.com> <4B0C0C12.7040907@zytor.com>	 <4B0C13F4.5090106@redhat.com> <1259083839.22249.1117.camel@gandalf.stny.rr.com>
In-Reply-To: <1259083839.22249.1117.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2009 09:30 AM, Steven Rostedt wrote:
> 
> For other archs, Linus showed some examples:
> 
> http://lkml.org/lkml/2009/11/19/349
> 

Yes; the key here is that the ABI-defined entry state is readily
mappable onto the state on entry to the __fentry__ function.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
