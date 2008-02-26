Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYBZGMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYBZGMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYBZGMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:12:33 -0500
Received: from relay2.sgi.com ([192.48.171.30]:51597 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752369AbYBZGMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:12:33 -0500
Date: Tue, 26 Feb 2008 00:12:29 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
Message-Id: <20080226001229.aea2f3d5.pj@sgi.com>
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

David wrote:
+static nodemask_t mpol_relative_nodemask(const nodemask_t *orig,
+					 const nodemask_t *rel)
+{
+	nodemask_t ret;
+	nodemask_t tmp;

Could you avoid needing the nodemask_t 'ret' on the stack, by passing
in a "nodemask_t *" pointer to where you want the resulting nodemask_t
written, rather than by returning it by value?

 static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
					 const nodemask_t *rel)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
