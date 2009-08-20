Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZHTWVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZHTWVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZHTWVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:21:09 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34130 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZHTWVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YMwOFkwzDjPv/jUlFpYWMJc+taKwdwQuAcm5F7xAwxjZQgiA8qioIn5EuJSHjxwwgz
         6ZlSiX1BI/gWU2aYKJ6Y/xAi/iso5QqZDTgNh1sbv6+3MqFki7MuzGBRMKZJH0RItSf4
         9cgbcWVfq5+GWOGzng96XBqI2XwB6/pBrCegU=
Date: Fri, 21 Aug 2009 00:19:58 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: perf: Problem compiling /tools/perf/Documentation in 2.6.31-rc6
Message-ID: <20090820221958.GA28182@Pilar.aei.mpg.de>
References: <4A8D9D56.5080107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8D9D56.5080107@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20.Aug'09 at 15:00:38 -0400, Gregory Haskins wrote:
> Hi Ingo,
> 
> I'm seeing this in 2.6.31-rc6:
> 
> ghaskins@dev:~/sandbox/git/fabric/linux-2.6/tools/perf/Documentation> make
>     SUBDIR ../
> make[1]: `PERF-VERSION-FILE' is up to date.
>     ASCIIDOC perf-examples.html
> ERROR: perf-examples.txt: line 1: manpage document title is mandatory
> FAILED: perf-examples.txt: line 8: illegal style name: From an e-mail by
> Ingo Molnar
> make: *** [perf-examples.html] Error 1
> 
> It could very well be pilot error.  Any ideas?

That is my fault. I am sorry everybody.

But Ingo already posted a pull request with the fix here,

http://lkml.org/lkml/2009/8/10/306


