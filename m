Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbYEESE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbYEESE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYEESEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:04:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:3809 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbYEESEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=czr59+n4YM+F2rWG9nUWbfN8MezxGHuyXnjISk78t3pikYd8yoWhcXCnVO5HPc9tMvzb0h7WzYrLn4yBeYvZO8TAA03QmqJh38l0L3UhSsJKkJq5r2d46wNS+JH7t8w3XXqKgaz5I3+GHxJ6UqYoZqDTayZCqWqT36F2268IX1U=
Message-ID: <84144f020805051104v4118bd81g344622d5962314a4@mail.gmail.com>
Date: Mon, 5 May 2008 21:04:42 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: SLUB: Increasing partial pages
Cc: "Matthew Wilcox" <matthew@wil.cx>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802161133000.25573@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080116195949.GO18741@parisc-linux.org>
	 <Pine.LNX.4.64.0801161219050.9694@schroedinger.engr.sgi.com>
	 <20080116214127.GA11559@parisc-linux.org>
	 <Pine.LNX.4.64.0801161347160.11353@schroedinger.engr.sgi.com>
	 <20080116221618.GB11559@parisc-linux.org>
	 <Pine.LNX.4.64.0801161421240.12024@schroedinger.engr.sgi.com>
	 <20080118191430.GD20490@parisc-linux.org>
	 <Pine.LNX.4.64.0801221142330.27692@schroedinger.engr.sgi.com>
	 <20080216190727.GH7657@parisc-linux.org>
	 <Pine.LNX.4.64.0802161133000.25573@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: e4031b55b8ad6794
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 12:00:00PM -0800, Christoph Lameter wrote:
> > > Patches that I would recommend to test individually if you could do it
> > > (get the series via git pull
> > > git://git.kernel.org/pub/scm/linux/kernel/git/christoph/vm.git performance):

On Sat, 16 Feb 2008, Matthew Wilcox wrote:
>  > With these patches applied to 2.6.24-rc8, the perf team are seeing
>  > oopses while running the benchmark.  They're currently trying to narrow
>  > down which of the patches it is.  I'll get an oops for you to study when
>  > they've figured that out.

On Sat, Feb 16, 2008 at 10:34 PM, Christoph Lameter <clameter@sgi.com> wrote:
>  There is also new code upstream now with significant changes that
>  affect performance. It may not be worthwhile to continue with 2.6.24-rc8
>  + patches.

Matthew, there are changes in 2.6.26-rc1 that might affect your
workload with SLUB:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=c124f5b54f879e5870befcc076addbd5d614663f

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=9b2cd506e5f2117f94c28a0040bf5da058105316

I would appreciate any updates where we currently stand with the
SLAB/SLUB performance regression on your TPC test. Thanks.

                Pekka
