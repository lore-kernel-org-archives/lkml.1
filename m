Return-Path: <linux-kernel-owner+w=401wt.eu-S1759867AbXEJSqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbXEJSqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXEJSqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:46:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51288 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754689AbXEJSqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:46:15 -0400
Date: Thu, 10 May 2007 11:46:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sct@redhat.com, adilger@clusterfs.com
Subject: Re: [PATCH 1/4] ext2: remove inode constructor
In-Reply-To: <84144f020705100556x2fd70556p37cde356520e515d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705101144250.10294@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705051256530.20886@sbz-30.cs.Helsinki.FI> 
 <20070509133948.814128f4.akpm@linux-foundation.org>
 <84144f020705100556x2fd70556p37cde356520e515d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Pekka Enberg wrote:

> Ok. I would appreciate any kind of heads-up when you're ready to eat
> these patches again. ;-)

If you have some more spare cycles: Try to extend this 
to get rid of the inode constructors in the other fs as well?

(And if you have even more time and are touching the call sites anyways: 
Kill off SLAB_CONSTRUCTOR_CTOR. It is always set and has no purpose in life left).

