Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbYKFGmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbYKFGmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYKFGma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:42:30 -0500
Received: from smtp-out.google.com ([216.239.45.13]:52120 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYKFGma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:42:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=gnoZLKoftknrLRDHrXuw/yoBaWGzJbni7VRc3y7xZnm1AGc7V9vCYmllgAiKpln4g
	UW9fu8Br/L/4aqUv8lFCA==
MIME-Version: 1.0
In-Reply-To: <20081106063012.GA15731@elte.hu>
References: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com>
	 <20081106061125.GA6384@elte.hu>
	 <b040c32a0811052216i4594a094gdcee3ae280cddec7@mail.gmail.com>
	 <20081106063012.GA15731@elte.hu>
Date: Wed, 5 Nov 2008 22:42:24 -0800
Message-ID: <b040c32a0811052242q767302cbx2667a68a8e058b6e@mail.gmail.com>
Subject: Re: [patch] sched: fix single-depth wchan output
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 10:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
> are you interested in adding /proc/<PID>/stacktrace? If yes then we
> could remove fp generation for 64-bit right now and add your
> stacktrace patch when you are done with it.

Yes, we had a patch internally at google to dump task stack trace via
procfs just like what you suggested.  I will get that patch out.

- Ken
