Return-Path: <linux-kernel-owner+w=401wt.eu-S1767702AbXEDFyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767702AbXEDFyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767703AbXEDFyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:54:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767702AbXEDFyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:54:38 -0400
Date: Thu, 3 May 2007 22:54:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Power Management: use mutexes instead of semaphores
Message-Id: <20070503225432.97dad06e.akpm@linux-foundation.org>
In-Reply-To: <20070427084322.GC4213@traven>
References: <20070427083857.GB4213@traven>
	<20070427084322.GC4213@traven>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 10:43:22 +0200 Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:

> the Power Management code uses semaphores as mutexes. use the mutex
> API instead of the (binary) semaphores

I know it's a little thing, but given a choice between

a) changelogs which use capital letters and fullstops and

b) changelogs which do not,

I think a) gives a better result.

I note that none of these patches added a #include <linux/mutex.h>.  Each C
file which uses mutexes should do that, rather than relying upon accidental
nested includes.  I hope you're checking for that.

