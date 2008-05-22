Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYEVQs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYEVQs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYEVQsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:48:47 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49484 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753452AbYEVQsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:48:46 -0400
Date: Thu, 22 May 2008 09:48:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: dhowells@redhat.com, mpm@selenic.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0805220948100.27587@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Pekka J Enberg wrote:

>  	BUG_ON(page->index < 0);
>  	BUG_ON(page->index >= MAX_ORDER);

Would someone explain to me what this is supposed to be doing?

