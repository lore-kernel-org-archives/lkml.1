Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYBEHzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYBEHzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYBEHyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:54:54 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52288 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYBEHyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:54:53 -0500
Date: Tue, 5 Feb 2008 09:54:51 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: Support for statistics to help analyze allocator behavior
In-Reply-To: <47A81513.4010301@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0802050952300.16488@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0802050923220.14675@sbz-30.cs.Helsinki.FI> <47A81513.4010301@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Eric Dumazet wrote:
> > Looks good but I am wondering if we want to make the statistics per-CPU so
> > that we can see the kmalloc/kfree ping-pong of, for example, hackbench
> > better?
> 
> AFAIK Christoph patch already have percpu statistics :)

Heh, sure, but it's not exported to userspace which is required for 
slabinfo to display the statistics.

			Pekka
