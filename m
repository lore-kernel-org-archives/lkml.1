Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbXDMMq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbXDMMq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXDMMq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:46:27 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:33800 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753972AbXDMMq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:46:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Qo+a3+P5YJC3zXKsJaKkex9hGal4LsGIokheTZhM+a3whJ5v7hOP88fpltKL59kJUOwTEQyPLg85HMpc056E9Mvv+3aJo9kwCnPRRdWRwdf9KBQtOBAhXyeorTb0jSVhcW6ubwkIn0DzRB7J1D+udy2AanNdVaZKRzhM8jnB+0U=  ;
X-YMail-OSG: vOa0ukcVM1mlpV1mxOpKK4OOY4SXEQywsV8iVEKWJkMNry4mzNr3U54BBpoIMhQZB_gKaKKxvQ--
Message-ID: <461F7B9A.80406@yahoo.com.au>
Date: Fri, 13 Apr 2007 22:46:18 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au> <20070413121347.GA30280@in.ibm.com>
In-Reply-To: <20070413121347.GA30280@in.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> On Fri, Apr 13, 2007 at 12:50:20PM +1000, Nick Piggin wrote:

>>It definitely seems like you can use some kernel functions, but the
>>ones I saw may just be systemtap facilities. But what is so surprising
>>about being able to call a kernel function when running in kernel
>>context? Perhaps there is some fundamental limitation of kprobes that
>>I don't understand.
> 
> 
> The main requirement for kprobes handlers is that they can't sleep. You
> could definitely call a kernel function from kprobe handlers as long as
> the function doesn't sleep.

That would be enough to access basically all the VM data structures.

-- 
SUSE Labs, Novell Inc.
