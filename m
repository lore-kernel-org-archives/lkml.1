Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbYCHB3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbYCHB3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbYCHB2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:28:53 -0500
Received: from relay2.sgi.com ([192.48.171.30]:52724 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756235AbYCHB2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:28:53 -0500
Date: Fri, 7 Mar 2008 19:28:45 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 2/2] mempolicy: use default_policy mode instead of
 MPOL_DEFAULT
Message-Id: <20080307192845.0492c6f9.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0803071722170.4611@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803071722170.4611@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> So instead of checking for comparisons against a mempolicy's mode to
> MPOL_DEFAULT or falling back stricly to MPOL_DEFAULT throughout the code,
> we should use the mode that is defined in this struct.

Is this just a stylistic choice?  That is, is the same machine
code produced either way?

If that's the case, could you briefly explain why you prefer
one style (default_policy.policy) over the other (MPOL_DEFAULT)?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
