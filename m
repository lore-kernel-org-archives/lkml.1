Return-Path: <linux-kernel-owner+w=401wt.eu-S966063AbXDGQkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966063AbXDGQkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966090AbXDGQkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:40:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:14369 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966063AbXDGQkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CwVrRLiJGfFpgJNBfzLyxCPwhAZKiyXTheVtYVuu/dJDv0eK6ms8TyrK26ZbfGoa+C//OkC8jxsdbnKVn+KEYrRJYielFtMFY5bwSLPxWfkS0QWhjCht3+0wCIQ0eoVh8QqjUwQHpf9h5h3ZN9tlSjQVslCk1poMKZtM/4Z9sak=
Message-ID: <a36005b50704070940q7c3c0835y47486523d2640b4b@mail.gmail.com>
Date: Sat, 7 Apr 2007 09:40:06 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
Cc: "Jakub Jelinek" <jakub@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Dave Jones" <davej@redhat.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       "pravin b shelar" <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46178676.3010704@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20060808070708.GA3931@localhost.localdomain>
	 <200608090826.28249.dada1@cosmosbay.com>
	 <200608090843.52893.dada1@cosmosbay.com>
	 <200703152010.35614.dada1@cosmosbay.com>
	 <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	 <20070405194942.1414c030.dada1@cosmosbay.com>
	 <20070407104339.6674336b.dada1@cosmosbay.com>
	 <20070407111849.GT355@devserv.devel.redhat.com>
	 <46178676.3010704@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/7/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> I am not sure what you want to say.

What Jakub meant is that it is OK for the kernel to reject using
unaligned 64-bit futexes.  Just return an error in all cases (not just
in some).
