Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbXKNHqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbXKNHqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 02:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXKNHqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 02:46:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:10060 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbXKNHqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 02:46:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=oT/Y15UDfvf4LMJ28Yg0Hs6kg2E0rhbgNg5CwxeI4L8lfFOvi0ciIel+qSDcW4m/HEI/p0jSf5cA47Djk7gdAVcKZbYeR8M/u+CmzJW7GaKL7zhdDz43w37x8a4v7YfiZ9sfafVTpSXeLmU4j9Boa1ODuqcnO4UF0Ts90mzCcdA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [BUG] New Kernel Bugs
Date: Wed, 14 Nov 2007 00:46:20 -0700
User-Agent: KMail/1.9.1
Cc: Theodore Tso <tytso@mit.edu>, Benoit Boissinot <bboissin@gmail.com>,
       Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <200711131739.45820.vda.linux@googlemail.com> <20071114072715.GO4250@stusta.de>
In-Reply-To: <20071114072715.GO4250@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711140046.20391.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 00:27, Adrian Bunk wrote:
> You missed the following in my email:
> "we slowly scare them away due to the many bug reports without any
>  reaction."
>
> The problem is that bug reports take time. If you go away from easy
> things like compile errors then even things like describing what does
> no longer work, ideally producing a scenario where you can reproduce it
> and verifying whether it was present in previous kernels can easily take
> many hours that are spent before the initial bug report.
>
> If the bug report then gets ignored we discourage the person who sent
> the bug report to do any work related to the kernel again.

Cannot agree more. I am in a similar position right now.
My patch to aic7xxx driver was ubmitted four times
with not much reaction from scsi guys.

Finally they replied and asked to rediff it against their
git tree. I did that and sent patches back. No reply since then.

And mind you, the patch is not trying to do anything
complex, it mostly moves code around, removes 'inline',
adds 'const'. What should I think about it?
--
vda
