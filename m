Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZKTBeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZKTBeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 20:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbZKTBef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 20:34:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbZKTBee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 20:34:34 -0500
Message-ID: <4B05F0EA.2090808@zytor.com>
Date: Thu, 19 Nov 2009 17:29:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Jeff Law <law@redhat.com>,
       rostedt@goodmis.org, David Daney <ddaney@caviumnetworks.com>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
References: <viy9pk4xossnb6m2v041qu00.1258665258503@email.android.com>   <4B05B7AD.20500@redhat.com> <1258670580.22249.1002.camel@gandalf.stny.rr.com> <4B05DBBF.5000804@redhat.com> <alpine.LFD.2.00.0911200122190.24119@localhost.localdomain> <alpine.LFD.2.00.0911191652430.2793@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911191652430.2793@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2009 04:59 PM, Linus Torvalds wrote:
> 
> [ Btw, looking at that, why are X86_L1_CACHE_BYTES and X86_L1_CACHE_SHIFT 
>   totally unrelated numbers? Very confusing. ]
> 

Yes, there is another thread to clean up that particular mess; it is
already in -tip:

http://git.kernel.org/tip/350f8f5631922c7848ec4b530c111cb8c2ff7caa

	-hpa
