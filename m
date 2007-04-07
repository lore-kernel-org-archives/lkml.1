Return-Path: <linux-kernel-owner+w=401wt.eu-S965025AbXDGCFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025AbXDGCFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 22:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965028AbXDGCFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 22:05:43 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:22853 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025AbXDGCFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 22:05:42 -0400
Subject: Re: [PATCH] timekeeping: drop irq-context clocksource polling
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, mingo@elte.hu
In-Reply-To: <20070406182100.9f205621.akpm@linux-foundation.org>
References: <20070405210316.785839431@mvista.com>
	 <20070406182100.9f205621.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 19:04:44 -0700
Message-Id: <1175911485.15973.144.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 18:21 -0700, Andrew Morton wrote:
> On Thu, 05 Apr 2007 14:03:16 -0700 Daniel Walker <dwalker@mvista.com> wrote:
> 
> > Boot tested on i386, compile tested on x86_64 .. However, I couldn't
> > find a !GENERIC_TIME that compiled without this change so it's untested..
> 
> I'm scratching my head over this statement.
> 
> Do you mean that none of grep -lv GENERIC_TIME arch/*/Kconfig compile?  Confused.

Yeah .. I tested 2 or 3 ARM configs that didn't have GENERIC_TIME , but
they failed .. I just assumed it was work in progress from the ARM
tree ..

Daniel

