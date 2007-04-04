Return-Path: <linux-kernel-owner+w=401wt.eu-S2992703AbXDDHQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992703AbXDDHQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 03:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992709AbXDDHQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 03:16:12 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:47631 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992703AbXDDHQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 03:16:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OMlorb0+MuSF90ROxuAgg9T6UIXDM6KUAvbTLD8Gp5+Ezwpe2pjTuECRgbEuZcK/D6mI4P41XLVaFaZ4V61i+O5cSWW7C4vSZfdNyCnfggfNzilbz8ffQOMjEAOT/vOzAoBDtKwDzaxUxJvZJ53ni1/A2xTDN76N+qNZNW6ouUI=
Message-ID: <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
Date: Wed, 4 Apr 2007 00:16:09 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [PATCH 0/3] FUTEX : new PRIVATE futexes, SMP and NUMA improvements
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       "pravin b shelar" <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703152010.35614.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20060808070708.GA3931@localhost.localdomain>
	 <200608090826.28249.dada1@cosmosbay.com>
	 <200608090843.52893.dada1@cosmosbay.com>
	 <200703152010.35614.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> But fact is POSIX defined PRIVATE and SHARED, allowing clear separation, and
> optimal performance if carefuly implemented. Time has come for linux to have
> better threading performance.

Now that I've been pointed to the thread I can comment on it.

Yes, this approach makes a lot of sense.  Programs which shared syn
objects without declaring them correctly are broken and deserve to
fail.  It would be quite a lot of change in libpthread but it's
manageable.

I haven't tested the code nor will I likely do until I get a Fedora
kernel with it.  So, convince DaveJ to take it for testing.
