Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbXGMFIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbXGMFIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbXGMFHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:07:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbXGMFHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:07:54 -0400
Date: Thu, 12 Jul 2007 22:07:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch 2.6.22-git] dev_vdbg(), available with -DVERBOSE_DEBUG
Message-Id: <20070712220734.d98a43f1.akpm@linux-foundation.org>
In-Reply-To: <200707122030.49465.david-b@pacbell.net>
References: <200707122030.49465.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 20:30:49 -0700 David Brownell <david-b@pacbell.net> wrote:

> This defines a dev_vdbg() call, which is enabled with -DVERBOSE_DEBUG.
> When enabled, dev_vdbg() acts just like dev_dbg().  When disabled, it
> is a NOP ... just like dev_dbg() without -DDEBUG.  The specific code
> was moved out of a USB patch, but lots of drivers have similar support.

I suppose we should find some way of telling people about this.  Maybe
in the `make help' output?
