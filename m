Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbYBKUpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbYBKUpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYBKUpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:45:47 -0500
Received: from relay1.sgi.com ([192.48.171.29]:44788 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751961AbYBKUpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:45:46 -0500
Date: Mon, 11 Feb 2008 12:45:45 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
In-Reply-To: <alpine.DEB.1.00.0802111156420.17652@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0802111244140.26158@schroedinger.engr.sgi.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0802111131270.24563@schroedinger.engr.sgi.com>
 <alpine.DEB.1.00.0802111135090.1671@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0802111146590.25590@schroedinger.engr.sgi.com>
 <alpine.DEB.1.00.0802111156420.17652@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, David Rientjes wrote:

> On Mon, 11 Feb 2008, Christoph Lameter wrote:
> 
> > Then you could follow through with the enum mempolicy thing 
> > throughtout. Why not use enum mempolicy in struct mempolicy?
> > 
> 
> Mempolicy flags, as I implemented them in patch 2 in this series, are not 
> integer constants that are enumerated starting at 0.  They are individual 
> bits that are shifted a pre-defined length and intersected with the 
> enumerated mode.  This allows both the mode and the flags to be stored in 
> the same object.

Ok. Now are you are making the same point that I did before. Lets leave 
enum out if we need to do these tricks with the upper bits.
