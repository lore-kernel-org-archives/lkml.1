Return-Path: <linux-kernel-owner+w=401wt.eu-S934828AbYCFQlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934828AbYCFQlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762015AbYCFQla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:41:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46760 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752119AbYCFQl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:41:29 -0500
Date: Thu, 6 Mar 2008 08:41:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Patrick McHardy <kaber@trash.net>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: replace horrible hack with ksize()
In-Reply-To: <Pine.LNX.4.64.0803061612290.4202@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0803060840540.13012@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803052319210.15759@sbz-30.cs.Helsinki.FI>
 <47CFF9B7.5060803@trash.net> <Pine.LNX.4.64.0803061612290.4202@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Pekka J Enberg wrote:

> Then ksize(p) will return the currently allocated size which is 32 bytes 
> when page size is 4 KB, and not 8 bytes. So it should be equivalent of 
> what the current code does.

True for SLAB. SLUB will actually allocate only 8 bytes.
