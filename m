Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbXHBA2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbXHBA2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 20:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbXHBA2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 20:28:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:57019 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXHBA2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 20:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=q1FNDYq9EH5vSgU+1kTbtKj3be7IMDcKDmwrVcanLeGz4D5TuIruN+x4wCWL7HFHNBYMKgTd5mqtZ1xuITAWYopL+ADstncMWjwip2OX6Yczm77OV65H7Kf+9DDVaG9n5+/zhZWqeQ0jUR6+y2BfuXgV91Y3sWCx4GLzO48LP4c=
Message-ID: <46B12516.4090006@googlemail.com>
Date: Thu, 02 Aug 2007 02:28:06 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: cpufreq.c:(.text+0xaf178): undefined reference to `cpufreq_gov_performance'
References: <a44ae5cd0708011631k7f476af2jcd01d2875f4b4b17@mail.gmail.com> <20070801165704.a26961b7.akpm@linux-foundation.org>
In-Reply-To: <20070801165704.a26961b7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 1 Aug 2007 16:31:46 -0700
> "Miles Lane" <miles.lane@gmail.com> wrote:
> 
>>   LD      .tmp_vmlinux1
>> drivers/built-in.o: In function `__cpufreq_governor':
>> cpufreq.c:(.text+0xaf178): undefined reference to `cpufreq_gov_performance'
>> cpufreq.c:(.text+0xaf18a): undefined reference to `cpufreq_gov_performance'
>> make: *** [.tmp_vmlinux1] Error 1
> 
> One for Thomas, I expect.

Is this patch :

cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch

Reverting it here fixes the error.

Gabriel
