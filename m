Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbXGECA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbXGECA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 22:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbXGECAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 22:00:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbXGECAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 22:00:20 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] Linux Kernel Markers
References: <20070703170843.204442953@polymtl.ca>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 04 Jul 2007 22:00:01 -0400
In-Reply-To: <20070703170843.204442953@polymtl.ca>
Message-ID: <y0mir8zr4ny.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> This updated version of the Linux Kernel Markers mostly adds a unique 16 bits
> per marker ID and a per-probe marker group. [...]

Could you motivate this part better?  It is not covered in the
documentation patch.

It seems to be a way of having a marker handling (callback) module
give alternate names/ids to markers.  If so, why, considering that
there is already a private void* callback parameter available to pass
data back to itself through?

Also, what if different marker handling modules want to set different
id/group numbers on the same set of markers?

- FChE
