Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbYAISWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbYAISWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYAISWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:22:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40403 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYAISWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:22:04 -0500
Date: Wed, 9 Jan 2008 18:21:57 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Roskin <proski@gnu.org>
Cc: benh@kernel.crashing.org, Dave Airlie <airlied@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com
Subject: Re: Replacement for page fault notifiers?
Message-ID: <20080109182157.GA32754@infradead.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi> <20080108203235.GA772@infradead.org> <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com> <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199902724.8050.11.camel@dv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 01:18:44PM -0500, Pavel Roskin wrote:
> notification without patching the kernel.  But if no such solution is
> found, I would also support reverting the patch that removed fault
> notifiers on i386.

With your fixation on not patching the kernel you sound like a windows
developer.  There is no problem with patching the kernel, but the best
patching of that kernel is that which happens upstream so please folks
start submitting an mmiotrace variant for kernel inclusion.

Then again I don't quite get why you absolutely want to track pagefaults
anyway.  Just hooking into ioremap and read*/write* and iomap +
ioread*/iowrite* would be much easier and also a lot faster.  It would
also allow adding a nice sysfs attribute to enable this per-device.

