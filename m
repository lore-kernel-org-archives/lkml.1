Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbYCVD10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbYCVD10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYCVD1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:27:19 -0400
Received: from main.gmane.org ([80.91.229.2]:60878 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbYCVD1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:27:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ben Pfaff <blp@cs.stanford.edu>
Subject: Re: [patch 2/9] Store max number of objects in the page struct.
Date: Fri, 21 Mar 2008 20:27:31 -0700
Message-ID: <87od975tgc.fsf@blp.benpfaff.org>
References: <20080317230516.078358225@sgi.com> <20080317230528.279983034@sgi.com> <1205917757.10318.1.camel@ymzhang> <Pine.LNX.4.64.0803191049450.29173@schroedinger.engr.sgi.com> <1205983937.14496.24.camel@ymzhang> <20080321152407.b0fbe81f.akpm@linux-foundation.org>
Reply-To: blp@cs.stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 76.14.48.172
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:SwcKrXBEzZUo9+pmlYuH/YLMxhQ=
Cc: linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> +#define USHRT_MAX	((u16)(~0U))
>> +#define SHRT_MAX	((s16)(USHRT_MAX>>1))
>> +#define SHRT_MIN	(-SHRT_MAX - 1)
>
> We have UINT_MAX and ULONG_MAX and ULLONG_MAX.  If these were actually
> UNT_MAX, ULNG_MAX and ULLNG_MAX then USHRT_MAX would make sense.
>
> But they aren't, so it doesn't ;)
>
> Please, let's call them USHORT_MAX, SHORT_MAX and SHORT_MIN.

SHRT_MIN, SHRT_MAX, and USHRT_MAX are the spellings used by
<limits.h> required in ISO-conforming C implementations.  That
doesn't mean that the kernel has to use those spellings, but it
does mean that those names are widely understood by C
programmers.
-- 
Ben Pfaff 
http://benpfaff.org

