Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXHBLU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXHBLU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbXHBLUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:20:51 -0400
Received: from styx.suse.cz ([82.119.242.94]:42832 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754057AbXHBLUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:20:50 -0400
Date: Thu, 2 Aug 2007 13:21:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ulrich Kunitz <kune@deine-taler.de>, Bret Towe <magnade@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Jan Kratochvil <honza@jikos.cz>, jakub@redhat.com
Subject: Re: Is PIE randomization breaking klibc binaries?
In-Reply-To: <20070802042942.GA4054@deine-taler.de>
Message-ID: <Pine.LNX.4.64.0708021316020.1779@jikos.suse.cz>
References: <46A667BD.5080106@redhat.com> <20070724220053.GA20531@deine-taler.de>
 <46A68003.6060901@redhat.com> <46A68118.9080902@zytor.com>
 <20070725063243.GA25148@deine-taler.de> <Pine.LNX.4.64.0707311326090.26532@jikos.suse.cz>
 <46AF24B2.8070900@zytor.com> <Pine.LNX.4.64.0707311418040.26532@jikos.suse.cz>
 <46AF27E6.5080008@zytor.com> <Pine.LNX.4.64.0708011604570.6311@jikos.suse.cz>
 <20070802042942.GA4054@deine-taler.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Ulrich Kunitz wrote:

> Here is the .config file. I used it directly with 60bfba7e8 and could 
> reproduce the bug. (All other builds after the patch could also 
> reproduce the bug.) 

Thanks, I used your .config against 60bfba7e8 on x86_64, and still can't 
seem to be able to reproduce the problem:

linux-w027:~ # echo "test" | ./klibc-1.5/usr/utils/shared/cat
test
linux-w027:~ # echo "test" | ./klibc-1.5/usr/utils/static/cat
test

hpa, were you successful reproducing this?

Bret, I can see that you also reported some related segfaults, what were 
your conditions that triggered it please?

-- 
Jiri Kosina
SUSE Labs
