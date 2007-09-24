Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbXIXWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbXIXWbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbXIXWbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:31:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33633 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328AbXIXWbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:31:12 -0400
Message-ID: <46F83A5F.1070606@oracle.com>
Date: Mon, 24 Sep 2007 15:29:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: lkml <linux-kernel@vger.kernel.org>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, hch@infradead.org,
       akpm <akpm@linux-foundation.org>, sam@ravnborg.org, davem@davemloft.net
Subject: Re: [PATCH/RFC] samples/: move kprobes sources to samples
References: <20070924145828.d279abac.randy.dunlap@oracle.com> <20070924222144.GA12041@Krystal>
In-Reply-To: <20070924222144.GA12041@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>> This is RFC patch 2/2.
>> Patch 1/2 introduces the samples/ infrastructure:
>>   http://lkml.org/lkml/2007/9/24/397
>>
> 
> Hi Randy,
> 
> I got this when building my markers (which looks alike your kprobes):
> 
> ld: samples/built-in.o: No such file: No such file or directory
> make: *** [.tmp_vmlinux1] Error 1
> 
> And the Makefile from samples does not seem to be executed. And why is
> there a Kbuild file in your first patch ?

samples/Kbuild should be renamed to samples/Makefile.
Sorry about that.

I made the kprobes files build only as modules.
You are probably attempting to build markers built-in, not as
modules?  That needs some makefile foo, I think.  Sam??


-- 
~Randy
Phaedrus says that Quality is about caring.
