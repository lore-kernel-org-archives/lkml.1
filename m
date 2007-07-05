Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbXGEPYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbXGEPYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbXGEPYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:24:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:60747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298AbXGEPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:24:05 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
To: Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 05 Jul 2007 17:23:11 +0200
References: <8CTJM-4Z1-27@gated-at.bofh.it> <8CU38-5E1-23@gated-at.bofh.it> <8DjNU-4bL-47@gated-at.bofh.it> <8DkTC-5Vy-11@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I6TAl-0002iC-W7@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/XBd9AV6EiaMv4+ozuA+lUyCEXAYYNjCbVhSB
 OFc3gdG1AvOAuUU3rYTp4jsnfPKBD4g9zqsFU2Vem/OUFNM8oa
 5sQHlvmWYQEmNgE81cNzw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:
> Alexey Dobriyan <adobriyan@gmail.com> writes:
>> On Tue, Jul 03, 2007 at 12:40:56PM -0400, Mathieu Desnoyers wrote:

>> > Use immediate values with lower d-cache hit in optimized version as a
>> > condition for scheduler profiling call.
>> 
>> I think it's better to put profile.c under CONFIG_PROFILING as
>> _expected_, so CONFIG_PROFILING=n users won't get any overhead, immediate or
>> not. That's what I'm going to do after test-booting bunch of kernels.
> 
> No, it's better to handle this efficiently at runtime e.g. for
> distribution kernels. Mathieu's patch is good

IMO you should combine them. For distibutions, it may be good to include
profiling support unconditionally, but how many of the vanilla kernel users
are going to use profiling at all?
-- 
A man inserted an advertisement in the classified: Wife Wanted."
The next day he received a hundred letters. They all said the
same thing: "You can have mine."
Friﬂ, Spammer: oztx1@nAQd3C.7eggert.dyndns.org wGhu@InUYZ.7eggert.dyndns.org
