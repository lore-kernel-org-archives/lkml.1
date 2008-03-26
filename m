Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYCZGXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYCZGXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 02:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYCZGXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 02:23:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55641 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbYCZGXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 02:23:15 -0400
Message-ID: <47E9EB77.9060909@cs.helsinki.fi>
Date: Wed, 26 Mar 2008 08:21:43 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@linux-foundation.org, mel@csn.ul.ie, olaf@aepfle.de,
       dan.yeisley@unisys.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix cache_cache bootstrap in kmem_cache_init()
References: <Pine.LNX.4.64.0803252357330.4422@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0803252023530.20780@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0803252023530.20780@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Will merge if I get confirmation that this indeed addresses the issue.

It fixes the problem reported by Daniel:

http://lkml.org/lkml/2008/3/25/249

But what I worry about is breaking setups that have memoryless nodes.

			Pekka
