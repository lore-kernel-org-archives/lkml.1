Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbZBJIzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbZBJIzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 03:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZBJIyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 03:54:47 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:41303 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZBJIyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 03:54:46 -0500
Date: Tue, 10 Feb 2009 11:54:37 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ian@beware.dropbear.id.au
Subject: Re: [1/1] w1: w1 temp calculation overflow fix.
Message-ID: <20090210085437.GA3513@ioremap.net>
References: <20090209214217.GA14958@ioremap.net> <20090209135641.0367a71f.akpm@linux-foundation.org> <20090209220830.GA15633@ioremap.net> <20090209144803.821aa33e.akpm@linux-foundation.org> <20090209153125.04210608.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209153125.04210608.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 03:31:25PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> On Mon, 9 Feb 2009 14:48:03 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > But we still don't have a _reason_.  Presumably the bug causes the
> > driver to malfunction in some manner.
> 
> ah-hah.  I discovered http://bugzilla.kernel.org/show_bug.cgi?id=12646
> 
> Now all is revealed!

Argh, I did not get that you need this description :)
Yes, reading sysfs temperature file may return wrong (overflown) value.

-- 
	Evgeniy Polyakov
