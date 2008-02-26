Return-Path: <linux-kernel-owner+w=401wt.eu-S1763457AbYBZRo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457AbYBZRo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbYBZRoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:44:20 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51809 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757478AbYBZRoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:44:19 -0500
Date: Tue, 26 Feb 2008 11:44:17 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
Message-Id: <20080226114417.c8948b61.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Perhaps I missed it, but could you elaborate on what sort of testing
these patches for MPOL_F_RELATIVE_NODES and MPOL_F_STATIC_NODES have
received?

The main reason I didn't push my version of these patches in December
was I figured it would take a week or three of obsessive-compulsive
testing to verify that we didn't break various corner cases of the
mbind/mempolicy system call interface.

In particular, do we know that Oracle works with this?  At least in
years past, when Andi was the primary developer here, he had some
good and detailed awareness of what it took to keep Oracle happy
with this NUMA memory policy apparatus.  I don't know if we still
have that awareness.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
