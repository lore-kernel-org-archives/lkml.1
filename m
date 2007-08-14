Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbXHNH4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbXHNH4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbXHNH4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:56:25 -0400
Received: from ozlabs.org ([203.10.76.45]:46062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbXHNH4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:56:23 -0400
Date: Tue, 14 Aug 2007 17:56:13 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Paul Mackerras <paulus@samba.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 07/12] powerpc: Fix size check for hugetlbfs
Message-ID: <20070814075613.GH8791@localhost.localdomain>
Mail-Followup-To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	stable@kernel.org, linuxppc-dev list <linuxppc-dev@ozlabs.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Justin Forbes <jmforbes@linuxtx.org>,
	Domenico Andreoli <cavokz@gmail.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Paul Mackerras <paulus@samba.org>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
	torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <20070814072244.882283903@mini.kroah.org> <20070814072918.GG15025@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814072918.GG15025@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 12:29:18AM -0700, Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> My "slices" address space management code that was added in 2.6.22
> implementation of get_unmapped_area() doesn't properly check that the
> size is a multiple of the requested page size. This allows userland to
> create VMAs that aren't a multiple of the huge page size with hugetlbfs
> (since hugetlbfs entirely relies on get_unmapped_area() to do that
> checking) which leads to a kernel BUG() when such areas are torn down.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: David Gibson <david@gibson.dropbear.id.au>

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
