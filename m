Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYBEHYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYBEHYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYBEHYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:24:33 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47248 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYBEHYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:24:33 -0500
Date: Tue, 5 Feb 2008 09:24:30 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: SLUB: Support for statistics to help analyze allocator behavior
In-Reply-To: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0802050923220.14675@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Mon, 4 Feb 2008, Christoph Lameter wrote:
> The statistics provided here allow the monitoring of allocator behavior
> at the cost of some (minimal) loss of performance. Counters are placed in
> SLUB's per cpu data structure that is already written to by other code.

Looks good but I am wondering if we want to make the statistics per-CPU so 
that we can see the kmalloc/kfree ping-pong of, for example, hackbench 
better?

			Pekka
