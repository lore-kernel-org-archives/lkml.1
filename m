Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYE3TF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYE3TF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 15:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYE3TFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 15:05:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbYE3TFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 15:05:15 -0400
Date: Fri, 30 May 2008 12:04:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, pavel@suse.cz
Subject: Re: [patch 2.6.26-rc4-git] PM: boot time suspend selftest
Message-Id: <20080530120451.5cb9d664.akpm@linux-foundation.org>
In-Reply-To: <20080530105948.GA12236@elte.hu>
References: <200805291333.42057.david-b@pacbell.net>
	<20080529162257.03426e48.akpm@linux-foundation.org>
	<20080530105948.GA12236@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 12:59:48 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > +	WARN_ON_ONCE(msec > (TEST_SUSPEND_SECONDS * 1000));
> > 
> > We should have a comment here explaining what we're warning about.  
> > Why would it take more that five seconds?
> 
> i asked for that because we had regressions in the past in the form of 
> "it takes one minute to resume".

It is not possible for a reader to learn this from either the kernel
source nor from the changelogs.

Hence...

