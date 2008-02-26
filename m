Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbYBZEC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbYBZEC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 23:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbYBZECq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 23:02:46 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36102 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752496AbYBZECq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 23:02:46 -0500
Date: Mon, 25 Feb 2008 22:02:42 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] mempolicy: convert MPOL constants to enum
Message-Id: <20080225220242.82aedaec.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802251931030.6021@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	<20080225212056.ca388983.pj@sgi.com>
	<alpine.DEB.1.00.0802251931030.6021@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> I don't suspect that a kernel developer is going
> to make such an egregious error.

Eh ... each bit of added clarity to the code reduces
errors.

Looking around the kernel, it really seems to me to be
a common coding to explicitly spell out enum values
when for some reason they actually matter.

Like most coding mechanisms, nothing guarantees anything.

It just nicely represents one particular detail, that
the values of these MPOL_* terms are not arbitrary.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
