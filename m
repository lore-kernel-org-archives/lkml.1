Return-Path: <linux-kernel-owner+w=401wt.eu-S1763995AbYCGTN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763995AbYCGTN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbYCGTNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:13:00 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:51780
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505AbYCGTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:13:00 -0500
Date: Fri, 7 Mar 2008 20:12:57 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Izik Eidus <izike@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: Notifier for Externally Mapped Memory (EMM) V1
Message-ID: <20080307191257.GN24114@v2.random>
References: <Pine.LNX.4.64.0803051600470.7481@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803051600470.7481@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 04:22:11PM -0800, Christoph Lameter wrote:
> +		if (e->callback) {
> +			x = e->callback(e, mm, op, start, end);
> +			if (x)
> +				return x;
[..]
> +
> +	if (emm_notify(mm, emm_referenced, address, address + PAGE_SIZE))
> +			referenced++;

This has still the same aging bug as in the RFC version.
