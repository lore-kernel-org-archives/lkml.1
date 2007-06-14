Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbXFNGYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbXFNGYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbXFNGYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:24:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23263 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbXFNGYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:24:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=i2tCwmJOtaLXyZ44um/b0rpTyfvE8Z8Iwms5Mi48fnu4xkPSNBp8KeDaSd2cY9YLe
	WZ+DiEtybUKfONJDUnXYQ==
Message-ID: <65dd6fd50706132323i9c760f4m6e23687914d0c46e@mail.gmail.com>
Date: Wed, 13 Jun 2007 23:23:59 -0700
From: "Ollie Wild" <aaw@google.com>
To: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [patch 0/3] no MAX_ARG_PAGES -v2
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>
In-Reply-To: <617E1C2C70743745A92448908E030B2A01AF860A@scsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070613100334.635756997@chello.nl>
	 <617E1C2C70743745A92448908E030B2A01AF860A@scsmsx411.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/07, Luck, Tony <tony.luck@intel.com> wrote:
> Above 5Mbytes, I started seeing problems.  The line/word/char
> counts from "wc" started being "0 0 0".  Not sure if this is
> a problem in "wc" dealing with a single line >5MBytes, or some
> other problem (possibly I was exceeding the per-process stack
> limit which is only 8MB on that machine).

Interesting.  If you're exceeding your stack ulimit, you should be
seeing either an "argument list too long" message or getting a
SIGSEGV.  Have you tried bypassing wc and piping the output straight
to a file?

Ollie
