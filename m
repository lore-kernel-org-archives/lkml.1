Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYBZErD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYBZErD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 23:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbYBZEqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 23:46:52 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39549 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750708AbYBZEqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 23:46:52 -0500
Date: Mon, 25 Feb 2008 22:46:48 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] mempolicy: convert MPOL constants to enum
Message-Id: <20080225224648.9f1c6b6f.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802252017310.14627@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	<20080225212056.ca388983.pj@sgi.com>
	<alpine.DEB.1.00.0802251931030.6021@chino.kir.corp.google.com>
	<20080225220242.82aedaec.pj@sgi.com>
	<alpine.DEB.1.00.0802252017310.14627@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
+	/* add additional MPOL_* modes here */

That doesn't explicitly say what I was most worried about saying, which
is that those MPOL_* terms have values visible in the kernel's public
API, and it does say more than might be true, and it doesn't explain
why it says what it says.

It kinda looks like an ugly "maybe this will shut Paul up patch
<grin>".  I'd rather leave the code the way it was than add that
comment ... sorry.

>  I'd like to avoid respinning this set

Ah - now we get to the real issue ?;).

There would be no need to respin; one could do just as you proposed
doing with the above change, queue a little add-on patch to the
existing set.

Really ... look around the kernel.  I believe you'll see many instances
of enum values being spelled out, even ones that count 0, 1, 2, ...,
in situations where the values are constrained by outside forces.
People really do avoid relying on the default enum behaviour having any
particular numbering.

Whatever ... do as you will.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
