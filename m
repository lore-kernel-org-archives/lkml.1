Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbYBNUDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbYBNUDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbYBNUCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:02:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:48719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753AbYBNUCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:02:50 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
Date: Thu, 14 Feb 2008 21:02:41 +0100
User-Agent: KMail/1.9.6
Cc: Paul Jackson <pj@sgi.com>, David Rientjes <rientjes@google.com>,
       Lee.Schermerhorn@hp.com, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, travis@sgi.com
References: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com> <Pine.LNX.4.64.0802141126340.375@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802141126340.375@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802142102.41420.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008 20:27:59 Christoph Lameter wrote:
> Excellent. Relative node masks are a nice feature and may allow us to even 
> cut down the size of the bitmasks for configurations with large numbers of 
> nodes.
> 
> Reviewed-by: Christoph Lameter <clameter@sgi.com>
> 
> ccing Mike since he may need something similar for cpu masks which are 
> getting a bit too large for 4k systems on x86_64.

You're saying the kernel should use these relative masks internally?

That means it would be impossible to run workloads that use the complete
machine because you couldn't represent all nodes.

Doesn't sound like a good idea.

-Andi

