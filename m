Return-Path: <linux-kernel-owner+w=401wt.eu-S1762686AbYCFUTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762686AbYCFUTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYCFUT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:19:28 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34785 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023AbYCFUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:19:27 -0500
Date: Thu, 6 Mar 2008 14:19:23 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 4/4] mempolicy: remove includes for duplicate
 headers
Message-Id: <20080306141923.45ce4214.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0803061136320.18590@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803061136160.18590@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803061136320.18590@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David R wrote:
> Remove #includes for:
> 
> 	linux/mempolicy.h	(already from linux/migrate.h)
> 	linux/mm.h		(already from linux/highmem.h)

I didn't see any problem offhand with the other patches 0 to 3 in this
set, but this patch 4/4 surprises me.

Perhaps I'm out of phase with what's customary in the kernel, but I
prefer directly including whatever headers I explicitly need.
Depending on some other header to drag in something you have explicit
need of anyway makes things more fragile.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
