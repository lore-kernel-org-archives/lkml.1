Return-Path: <linux-kernel-owner+w=401wt.eu-S1761001AbYBKTc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001AbYBKTc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758895AbYBKTcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:32:17 -0500
Received: from relay1.sgi.com ([192.48.171.29]:60160 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758230AbYBKTcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:32:16 -0500
Date: Mon, 11 Feb 2008 11:32:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
In-Reply-To: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0802111131270.24563@schroedinger.engr.sgi.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, David Rientjes wrote:

> The mempolicy mode constants, MPOL_DEFAULT, MPOL_PREFERRED, MPOL_BIND,
> and MPOL_INTERLEAVE, are better declared as part of an enum for type
> checking.
> 
> The policy member of struct mempolicy is also converted from type short
> to type unsigned short.  A negative policy does not have any legitimate
> meaning, so it is possible to change its type in preparation for adding
> optional mode flags later.

The second paragraphs seems to indicate that such an approach does not 
work since we also use MPOL_xx constants to set flags in the memory 
policies?

