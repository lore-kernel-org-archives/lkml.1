Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXFDSju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXFDSju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXFDSjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:39:43 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38892 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754342AbXFDSjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:39:43 -0400
Date: Mon, 4 Jun 2007 11:39:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ethan Solomita <solo@google.com>
cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@google.com>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
In-Reply-To: <465FB6CF.4090801@google.com>
Message-ID: <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>
References: <465FB6CF.4090801@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Ethan Solomita wrote:

> The dirty map is only cleared (or freed) when the inode is cleared.
> At that point no pages are attached to the inode anymore and therefore it can
> be done without any locking. The dirty map therefore records all nodes that
> have been used for dirty pages by that inode until the inode is no longer
> used.
> 
> Originally by Christoph Lameter <clameter@sgi.com>

You should preserve my Signed-off-by: since I wrote most of this. Is there 
a changelog?

