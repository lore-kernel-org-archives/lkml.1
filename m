Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZKRDhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZKRDhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZKRDhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:37:45 -0500
Received: from smtp-out.google.com ([216.239.45.13]:49128 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZKRDho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:37:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=M2EMtUiabUMlQKDifQSfJ8jTL/B0gKKe0jReOK42n8tW0eiUVyFD9zCFWG4imbiLp
	wzmcrT2jrTS4IIjcZxQRg==
Date: Tue, 17 Nov 2009 19:37:41 -0800
From: Michel Lespinasse <walken@google.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
Message-ID: <20091118033741.GB23808@google.com>
References: <20091117074655.GA14023@google.com> <20091117081817.GA7963@elte.hu> <1258448121.7816.29.camel@laptop> <4B02CC46.4020506@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B02CC46.4020506@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 08:16:06AM -0800, Darren Hart wrote:
>> Darren has recently been putting a lot of effort in making a futex test
>> suite:
>>
>> http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git
>>
>> Its not yet complete, but hopefully it will soon be :-)
>
> Michael, would you be willing to include a version of this test in the  
> above test suite? If so, then in keeping with the rest of the test suite, 
> I would recommend splitting into two tests, one of each opcode being 
> tested, and  add argument to define thread count. The run.sh script would 
> then run each thread count as a separate test run.

I had a quick look at the tree (using the http interface). I sure would not
mind adding the tests, and the futextest.h file would make them look
quite cleaner than my previous version. Just to be sure, would you put them
under performance/ or stress/ ? This would be the first test to be added
in these directories in any case, right ? (just asking in case I missed
something obvious).

And if Hitoshi wants to do it first, I sure won't mind the help either :)


-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
