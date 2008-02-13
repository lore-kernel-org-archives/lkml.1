Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbYBMOb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbYBMOb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYBMObW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:31:22 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46365 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752956AbYBMObV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:31:21 -0500
Date: Wed, 13 Feb 2008 08:31:18 -0600
From: Jack Steiner <steiner@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, Andrea Arcangeli <andrea@qumranet.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com
Subject: Re: [patch 0/6] MMU Notifiers V6
Message-ID: <20080213143114.GA26715@sgi.com>
References: <20080208220616.089936205@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208220616.089936205@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> GRU
> - Simple additional hardware TLB (possibly covering multiple instances of
>   Linux)
> - Needs TLB shootdown when the VM unmaps pages.
> - Determines page address via follow_page (from interrupt context) but can
>   fall back to get_user_pages().
> - No page reference possible since no page status is kept..

I applied the latest mmuops patch to a 2.6.24 kernel & updated the
GRU driver to use it. As far as I can tell, everything works ok.
Although more testing is needed, all current tests of driver functionality
are working on both a system simulator and a hardware simulator.

The driver itself is still a few weeks from being ready to post but I can
send code fragments of the portions related to mmuops or external TLB
management if anyone is interested.


--- jack
