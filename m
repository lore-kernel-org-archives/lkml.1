Return-Path: <linux-kernel-owner+w=401wt.eu-S932906AbZJFRfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbZJFRfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932879AbZJFRfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:35:16 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:21822 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbZJFRfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:35:15 -0400
Date: Tue, 6 Oct 2009 10:26:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] perf build questions
Message-Id: <20091006102626.8b4f7810.randy.dunlap@oracle.com>
In-Reply-To: <1254818939.21044.120.camel@laptop>
References: <20091005131729.78444bfb.randy.dunlap@oracle.com>
	<1254818939.21044.120.camel@laptop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4ACB7F9F.0145:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Oct 2009 10:48:59 +0200 Peter Zijlstra wrote:

> On Mon, 2009-10-05 at 13:17 -0700, Randy Dunlap wrote:
> > Hi,
> > 
> > How do I build 'perf' for an i386 target when running on x86_64?
> 
> make NO_64BIT=1

$ make NO_64BIT=1 all
$ file perf
perf: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), for GNU/Linux 2.6.4, dynamically linked (uses shared libs), not stripped


Shouldn't that be a 32-bit executable for i386?
Am I confused?  (you don't have to answer that)


> > and how do I do 'perf' cross-builds in general?
> 
> make CC=arm-linux-gcc AR=arm-linux-ar STRIP=arm-linux-strip
> 
> I think,.. but I don't have full cross build environments, just the bare
> binutils+gcc bits to cross build kernels.
> 
> > Also, I see build errors/warnings (-Werror).  Others aren't seeing these?
> > Just due to my gcc version?
> 
> Didn't see any here, but what frederic said..



---
~Randy
