Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0BRNrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 08:47:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0BRNrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 08:47:11 -0500
Subject: Re: perf record and multiple events
From: Peter Zijlstra <peterz@infradead.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <20100217173822.GA4137@us.ibm.com>
References: <20100217173822.GA4137@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 14:47:01 +0100
Message-ID: <1266500821.26719.649.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 17:38 +0000, Eric B Munson wrote:
> While testing perf record I found that when multiple events are specified
> on the command line, i.e. perf record -e dTLB-misses -e cache-misses,
> the are lumped into a single category on output from perf report.  The
> same event specification gives two event categories when using perf stat.
> Is this working as expected or should I see seperate entries in the report
> for each event?

The tools currently lack support for this, but patches are welcome.

