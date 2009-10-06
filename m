Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbZJFItf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbZJFItf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbZJFIte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:49:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:51515 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbZJFIte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:49:34 -0400
Subject: Re: [patch] perf build questions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091005131729.78444bfb.randy.dunlap@oracle.com>
References: <20091005131729.78444bfb.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 10:48:59 +0200
Message-Id: <1254818939.21044.120.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 13:17 -0700, Randy Dunlap wrote:
> Hi,
> 
> How do I build 'perf' for an i386 target when running on x86_64?

make NO_64BIT=1

> and how do I do 'perf' cross-builds in general?

make CC=arm-linux-gcc AR=arm-linux-ar STRIP=arm-linux-strip

I think,.. but I don't have full cross build environments, just the bare
binutils+gcc bits to cross build kernels.

> Also, I see build errors/warnings (-Werror).  Others aren't seeing these?
> Just due to my gcc version?

Didn't see any here, but what frederic said..

