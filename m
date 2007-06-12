Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbXFLCST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbXFLCST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 22:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbXFLCSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 22:18:12 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:25956 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757204AbXFLCSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 22:18:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=af85Cv/4k9eJ7c6CcTA0upum2T5tUGZhMpslcbfkNgPKwlwLkxXYhUdZfL0TamLrV0bN3XT5W6QJdcs2gcW/8ExMs/kmzT5+6dfKLiDfflGz3JPll3RqCtcIzcX7pk6J5GNwy2nsKi9yDYNgRkxolN6UO6v7QCFnZvwRdHnKKUI=  ;
X-YMail-OSG: 0kLSkGMVM1mfXqyZAPKa83369L.LiQsudEihMDaCSguYbqqTKBHW9CJ1SYUxQboAwbCCsSqKNQ--
Message-ID: <466E0258.2070407@yahoo.com.au>
Date: Tue, 12 Jun 2007 12:18:00 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: William Lee Irwin III <wli@holomorphy.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: why does the macro "ZERO_PAGE" take an argument?
References: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain> <4667EC18.4080904@yahoo.com.au> <Pine.LNX.4.64.0706070731250.14994@localhost.localdomain> <a781481a0706070439p6dda152l37e475ae0fa698ef@mail.gmail.com> <Pine.LNX.4.64.0706070750540.16051@localhost.localdomain> <4668412D.3030506@zytor.com> <20070607192911.GV6909@holomorphy.com> <46687598.2040701@zytor.com>
In-Reply-To: <46687598.2040701@zytor.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> William Lee Irwin III wrote:
> 
>>Robert P. J. Day wrote:
>>
>>>>although it's not clear where in the source tree are the invocations
>>>>that would actually make a difference to a MIPS system, which is why
>>>>i've CC'ed ralf on this.  i'm sure he can clear this up. :-)
>>
>>On Thu, Jun 07, 2007 at 10:32:29AM -0700, H. Peter Anvin wrote:
>>
>>>x86 could also benefit from coloured zeropages.  In fact, I thought it
>>>already had them (K8 wants as many as 8.)
>>
>>How would one demonstrate the beneficial effect of such?
> 
> 
> Dean Gaudet at Transmeta did some benchmarking using SPEC.  If I recall
> his numbers correctly (this is from memory, mind you) on Transmeta
> Efficeon, which has 2-way virtual cache tagging with hardware recovery,
> zeropage coloring was a 1.5% performance improvement.

I'm surprised that the benchmark made such use of zero pages so as to
be worthwhile. I'm sitting on a patch which removes the zero page from
the page fault fastpath completely which I'd like to try out in -mm...

-- 
SUSE Labs, Novell Inc.
