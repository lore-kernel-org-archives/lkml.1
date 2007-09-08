Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbXIHHhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbXIHHhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXIHHhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:37:03 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:30705 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751386AbXIHHhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:37:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NRYNrLY6iXbEnztErIf8UTlL3/HMGhKebCOs9tDQtCIkvO8hmSOWDfKsfB9YGTwUfdAawRUEYA7VeMJiVG4+DoI7VbbBGpQDs8vaGO0vQGW0zNke6JFZflsytv1NhduR59W7pD713lHHUSdQulYHDQ2iFtvCZ4vCqIH4mZcJGmk=  ;
X-YMail-OSG: igrsRHEVM1lTKVusJYEf4ZoA2RVfBZLYqFn8a4nEXd5owSb7yXXzYKOBjw_WU8JdSNubKh91_rFNaeiHP1B47zplM4oREdR1XeJJMVEJD2oIlnTYcMQUz25dcCfQzA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Intel Memory Ordering White Paper
Date: Sun, 9 Sep 2007 03:34:27 +1000
User-Agent: KMail/1.9.5
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
References: <200709071526.51169.jesse.barnes@intel.com> <200709081854.57549.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0709080020040.9047@evo.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709080020040.9047@evo.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709090334.27677.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 September 2007 09:20, Linus Torvalds wrote:
> On Sat, 8 Sep 2007, Nick Piggin wrote:
> > So, can we finally noop smp_rmb and smp_wmb on x86?
>
> Did AMD already release their version? If so, we should probably add a
> commit that does that in somewhat early 2.6.24 rc, and add the pointers to
> the whitepapers in the commit message.

http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/24593.pdf

AMD64 Architecture Programmer's Manual Volume 2: System Programming
section 7.2: Multiprocessor Memory Access Ordering, a paragraph on the
first page says

"Loads do not pass previous loads (loads are not re-ordered). Stores do
not pass previous stores (stores are not re-ordered)"

So, yes, it should be easy to do.
