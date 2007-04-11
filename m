Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXDKKKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXDKKKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXDKKKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:10:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:31164 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXDKKKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=llzst5I86aJL3twW6x80wk5kl0/Nl1EoSzVuPWgep7FCCcRBMIPWZCJV2PIvrisrZoCAbqO4mDzHtj0cvV77xaPhr40lDMyTG4aCBP4+vFqTSyRcoNh9m9g+CXERELzLrZiQmxAvXsFUrKrLoW03IftfeEA/J5kGST5BjFpk0LQ=
Message-ID: <ac8af0be0704110310n1f237e2el6f34365c4aaa5969@mail.gmail.com>
Date: Wed, 11 Apr 2007 18:10:33 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: Why kmem_cache_free occupy CPU for more than 10 seconds?
Cc: "Paul Jackson" <pj@sgi.com>, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1176285976.6893.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0704102317q50fe72b1m9e4825a769a63963@mail.gmail.com>
	 <84144f020704102353r7dcc3538u2e34237d3496630e@mail.gmail.com>
	 <ac8af0be0704110214qdca2ee9t3b44a17341e53730@mail.gmail.com>
	 <20070411025305.b9131062.pj@sgi.com> <1176285976.6893.27.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2007-04-11 at 02:53 -0700, Paul Jackson wrote:
> > I'm confused - which end of ths stack is up?
> >
> > cpuset_exit doesn't call do_exit, rather it's the other
> > way around.  But put_files_struct doesn't call do_exit,
> > rather do_exit calls __exit_files calls put_files_struct.
>
> I'm guessing its x86_64 which generates crap traces.
>
Yes, it's x86_64. Is there a reliable way to generate stack traces under x86_64?
Can enabling "[ ] Compile the kernel with frame pointers" help?
