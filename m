Return-Path: <linux-kernel-owner+w=401wt.eu-S1761228AbXGJBaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228AbXGJBaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759931AbXGJBaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:30:04 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:31881 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751747AbXGJBaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:30:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=U+t1TaI8/QI/NaW3DrBg7Jzw0gTEh4i6Ac3USjfHcRdgU9lJPKL9Ad9bQse2sg0Lc8wqxTpcxrMf800WPyiq65EbQfGQXxAKZu+/kvBIO1mKQRR1qly8Gk1cwQXqpglwuJB7EcJrPxWeHaejkBN/r00zm65H2/8I6nbpxS1FCSo=  ;
X-YMail-OSG: 8yg_tO4VM1nMap7YwQUyqKWPwgOMXhBSUKymCIOluezpon4AkuTyJQhdU63rQgH0Dlij6mUtmw--
Message-ID: <4692E111.5000305@yahoo.com.au>
Date: Tue, 10 Jul 2007 11:29:53 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Pavel Machek <pavel@ucw.cz>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <4691BC0F.8050909@yahoo.com.au> <20070709135205.GB3216@elf.ucw.cz> <200707091830.48074.a1426z@gawab.com>
In-Reply-To: <200707091830.48074.a1426z@gawab.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Pavel Machek wrote:

>>In the end, you'll get rid of freezer problems, but will have two
>>kernels to care about, and certainly more conventional design. I do
>>not think I have time to try that (and don't think freezer problems
>>are _that_ bad in the first place), but some interested soul could
>>certainly try it.
> 
> 
> Who said we need two kernels?  You could inline it like Xen, which would give 
> you one kernel with two modes:  normal and hibernate.


kexec can boot the currently running kernel image. There is no
need for two kernels.

-- 
SUSE Labs, Novell Inc.
