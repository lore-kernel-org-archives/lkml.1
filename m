Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbXH0MOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbXH0MOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbXH0MN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:13:59 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:36290 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756165AbXH0MN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:13:58 -0400
Message-ID: <388216835.20155@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 27 Aug 2007 20:13:54 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to find out how many other processes share VM with $PID?
Message-ID: <20070827121354.GA5616@mail.ustc.edu.cn>
References: <200708271256.31874.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708271256.31874.vda.linux@googlemail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denys,

On Mon, Aug 27, 2007 at 12:56:31PM +0100, Denys Vlasenko wrote:
> Hi,
> 
> I was a bit frustrated by bad quality of memory usage info
> from top and ps, and decided to write my own utility.
> 
> One problem I don't know how to solve is how to avoid counting
> twice (or more) memory used by processes which share VM
> (by use of CLONE_VM flage to sys_clone).
> 
> I know how to detect and correctly account for threads
> (processes created with CLONE_THREAD), but how to detect non-threads
> with shared VM?

There is a nice LWN article on this issue:
        ELC: How much memory are applications really using?
        http://lwn.net/Articles/230975/

Another helpful patch could be:
        maps: PSS(proportional set size) accounting in smaps
        http://lkml.org/lkml/2007/8/19/23

Fengguang

