Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZBHXx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZBHXx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 18:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZBHXxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 18:53:49 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:52315 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbZBHXxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 18:53:48 -0500
Date: Sun, 8 Feb 2009 23:51:49 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: x86: spinlocks: define dummy __raw_spin_is_contended
Message-ID: <20090208235149.GA23217@linux-mips.org>
References: <20090208180341.GC11398@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208180341.GC11398@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 01:03:41PM -0500, Kyle McMartin wrote:

> From: Kyle McMartin <kyle@redhat.com>
> 
> Architectures other than mips and x86 are not using ticket
> spinlocks. Therefore, the contention on the lock is meaningless,
> since there is nobody known to be waiting on it (arguably /fairly/
> unfair locks) Dummy it out to return 0 on other architectures.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Looks good.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
