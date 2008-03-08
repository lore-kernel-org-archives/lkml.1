Return-Path: <linux-kernel-owner+w=401wt.eu-S1761960AbYCHBfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960AbYCHBfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbYCHBfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:35:46 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49352 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752515AbYCHBfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:35:46 -0500
Date: Fri, 7 Mar 2008 19:35:43 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 2/2] mempolicy: use default_policy mode instead of
 MPOL_DEFAULT
Message-Id: <20080307193543.6a55ff8d.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0803071730340.6241@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803071722170.4611@chino.kir.corp.google.com>
	<20080307192845.0492c6f9.pj@sgi.com>
	<alpine.DEB.1.00.0803071730340.6241@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> I chose this because checks in mpol_new() to return NULL if the mode is 
> MPOL_DEFAULT is purely based on the fact that, as the default system 
> policy, policy task or VMA pointers are set to &default_policy.

You're just as fast!

Reasonable answer - thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
