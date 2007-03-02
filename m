Return-Path: <linux-kernel-owner+w=401wt.eu-S2992635AbXCBROL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992635AbXCBROL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992630AbXCBROK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:14:10 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:14820 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992635AbXCBROJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:14:09 -0500
Message-ID: <45E85E10.2020608@sw.ru>
Date: Fri, 02 Mar 2007 20:25:36 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kirill Korotaev <dev@openvz.org>, ckrm-tech@lists.sourceforge.net,
       xemul@sw.ru, linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
       menage@google.com
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
 top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>	<20070301113900.a7dace47.pj@sgi.com> <45E84682.6040500@openvz.org> <20070302085224.48212452.akpm@linux-foundation.org>
In-Reply-To: <20070302085224.48212452.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

>>>I'm wagering you'll break either the semantics, and/or the
>>>performance, of cpusets doing this.
>>
>>I like Paul's containers patch. It looks good and pretty well.
>>After some of the context issues are resolved it's fine.
>>Maybe it is even the best way of doing things.
> 
> 
> Have you thought about the relationship between it and UBC?
Sure.

Mostly containers patch does 2 things:
1. user space interfaces (if people don't like system calls used in UBC
  we are fine with filesystems approach. why not?)
2. context handling

So (1) is ok with us.
(2) requires some more work to be done before we are fine.
Actually all we want is lockless context handling all over the code
and looks like it is clear how to do it. Good.

UBC on the other hand can provide containers subsystems, i.e.
memory and other resources accounting and limiting etc.
This is what we are working on right now.

Thanks,
Kirill

