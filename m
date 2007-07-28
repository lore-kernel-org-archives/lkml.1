Return-Path: <linux-kernel-owner+w=401wt.eu-S938645AbXG1A7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938645AbXG1A7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 20:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938353AbXG1A7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 20:59:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:49776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938352AbXG1A7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 20:59:37 -0400
Date: Sat, 28 Jul 2007 02:59:20 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Chris Snook <csnook@redhat.com>
Cc: tim.c.chen@linux.intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Volanomark slows by 80% under CFS
Message-ID: <20070728005920.GA31622@v2.random>
References: <1185573687.19777.44.camel@localhost.localdomain> <46AA8E57.8010105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AA8E57.8010105@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 08:31:19PM -0400, Chris Snook wrote:
> I think Volanomark is being pretty stupid, and deserves to run slowly, but 

Indeed, any app doing what volanomark does is pretty inefficient.

But this is not the point. I/O schedulers are pluggable to help for
inefficient apps too. If apps would be extremely smart they would all
use async-io for their reads, and there wouldn't be the need of
anticipatory scheduler just for an example.

The fact is there's no technical explanation for which we're forbidden
to be able to choose between CFS and O(1) at least at boot time.
