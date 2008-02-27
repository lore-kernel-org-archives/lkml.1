Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbYB0Tfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbYB0Tfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbYB0Tfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:35:37 -0500
Received: from relay2.sgi.com ([192.48.171.30]:48140 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757517AbYB0Tf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:35:27 -0500
Date: Wed, 27 Feb 2008 11:35:26 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] mempolicy: convert MPOL constants to enum
In-Reply-To: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0802271134150.1790@schroedinger.engr.sgi.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, David Rientjes wrote:

>  struct mempolicy {
>  	atomic_t refcnt;
> -	short policy; 	/* See MPOL_* above */
> +	unsigned short policy; 	/* See MPOL_* above */

The point here is to have a 16 bit value? There are no space savins due to 
the alignment requirement of the union. Isnt it possible to use the enum 
here? If not then what is the point of the enum?

