Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZKTTMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZKTTMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZKTTML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:12:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbZKTTML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:12:11 -0500
Message-ID: <4B06E8BF.5090908@zytor.com>
Date: Fri, 20 Nov 2009 11:06:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: [PATCH] gcc mcount-nofp was Re: BUG: GCC-4.4.x changes the function
 frame on some functions
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>	 <20091119072040.GA23579@elte.hu>	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>	 <1258653562.22249.682.camel@gandalf.stny.rr.com>	 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>	 <alpine.LFD.2.00.0911191026420.2793@localhost.localdomain>	 <20091119184716.GA25458@elte.hu>	 <1258657614.22249.824.camel@gandalf.stny.rr.com>	 <87iqd54iz5.fsf_-_@basil.nowhere.org> <1258720459.22249.1018.camel@gandalf.stny.rr.com>
In-Reply-To: <1258720459.22249.1018.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2009 04:34 AM, Steven Rostedt wrote:
>>
>> If there's interest I can polish it up and submit formally.
> 
> I would definitely be interested, and I would also be willing to test
> it.
> 

I don't think there is any question that interception at the
architectural entry point would be the right thing to do.  As such, it
would be great to get this patch productized.

	-hpa
