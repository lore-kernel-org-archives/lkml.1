Return-Path: <linux-kernel-owner+w=401wt.eu-S1031279AbXEASjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031279AbXEASjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031280AbXEASjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:39:48 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:12911 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031279AbXEASjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MlP9arjqR4OEWiG4WUEaxsQJo95+aVvmm+k1JmIs03jPMsiOVte3mvPLX3lAJEb7ZGwgUimTaRSCDyKXVdKQ8wmLCCk29dmq88n7Q29F3GkrrZ5ggjJfEfy3E37TEMgWU0UK1n8hAN+mhJwwP1jIbx6Em0QorRv9LaMQsew+5+k=
Message-ID: <a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com>
Date: Tue, 1 May 2007 11:39:46 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Bill Irwin" <bill.irwin@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
In-Reply-To: <20070501172937.GQ26598@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070404172931.GM2986@holomorphy.com>
	 <20070404194829.1a93d8fd.dada1@cosmosbay.com>
	 <20070404181050.GN2986@holomorphy.com>
	 <20070409165315.4704021f.akpm@linux-foundation.org>
	 <20070410004201.GA2986@holomorphy.com>
	 <20070501172937.GQ26598@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Bill Irwin <bill.irwin@oracle.com> wrote:
> A sort of note for me to refer back to when I get the rest of the way
> here. AIX does this with getrusage(RUSAGE_THREAD,...), Solaris with
> getrusage(RUSAGE_LWP,...),

RUSAGE_LWP is a remnant of Solaris' M-on-N thread library days.  No
reason to got there.  Use RUSAGE_THREAD.  Even though the kernel calls
the process and process group, at userland these are threads and
processes.
