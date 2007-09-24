Return-Path: <linux-kernel-owner+w=401wt.eu-S1759671AbXIXRzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671AbXIXRzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbXIXRzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:55:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41235 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbXIXRzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:55:03 -0400
Date: Mon, 24 Sep 2007 18:55:00 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] Seq_file add support for sorted list
Message-ID: <20070924175500.GA2435@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070924164950.006047409@polymtl.ca> <20070924165426.841607414@polymtl.ca> <20070924173759.GA1608@infradead.org> <20070924175252.GA28347@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924175252.GA28347@Krystal>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 01:52:52PM -0400, Mathieu Desnoyers wrote:
> As they are currently implemented, the markers use the sorted module
> list for marker listing, but I can change their implementation so they
> do not require this (and make it a subsequent patch instead).
> 
> I could do that to diminish the patchset size a little more. However, it
> implies using an interface with a known race condition. Could we just
> post this as two different patchsets instead ? I really think the sorted
> module list would be important to get in and I don't like to use buggy
> unfixed lower level functions.

Given that we want to fix the the race I think keeping it as-is is
fine.  I didn't realize you depend on the new behaviour.
