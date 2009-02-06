Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZBFQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZBFQ5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZBFQ5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:57:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45566 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbZBFQ5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:57:06 -0500
Date: Fri, 6 Feb 2009 17:56:56 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] mmu_notifiers destroyed by __mmu_notifier_release()
	retain extra mm_count.
Message-ID: <20090206165656.GP14011@random.random>
References: <20090205172303.GB8559@sgi.com> <alpine.DEB.1.10.0902051427280.13692@qirst.com> <20090205200214.GN8577@sgi.com> <alpine.DEB.1.10.0902051844390.17441@qirst.com> <20090206013805.GL14011@random.random> <20090206014400.GM14011@random.random> <20090206125845.GC8559@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206125845.GC8559@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glad you are ok with mandatory unregister, it wasn't a problem for GRU
either and the auto-mm-pinning gives peace of mind.

On Fri, Feb 06, 2009 at 06:58:45AM -0600, Robin Holt wrote:
> Sorry for the noise.

No prob from my part, one more review and refresh of correctness of
current code didn't hurt ;).
