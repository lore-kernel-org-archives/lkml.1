Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYI3MOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYI3MOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYI3MOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:14:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbYI3MOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:14:45 -0400
Message-ID: <48E217C2.4080802@linux-foundation.org>
Date: Tue, 30 Sep 2008 07:12:50 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rusty@rustcorp.com.au, jeremy@goop.org,
       ebiederm@xmission.com, travis@sgi.com, herbert@gondor.apana.org.au,
       xemul@openvz.org
Subject: Re: [patch 3/4] cpu alloc: The allocator
References: <20080929193500.470295078@quilx.com>	 <20080929193516.278278446@quilx.com>	 <1222756559.10002.23.camel@penberg-laptop>	 <48E20F98.4010106@linux-foundation.org> <1222775286.10002.38.camel@penberg-laptop>
In-Reply-To: <1222775286.10002.38.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> 
> I think you're confusing it to "nr_units" or, alternatively, I need new
> glasses.
> 

You are right. units is debri from earlier revs and has no function today.


Subject: cpu_alloc: Remove useless variable

The "units" variable is a leftover and has no function at this point.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/mm/cpu_alloc.c
===================================================================
--- linux-2.6.orig/mm/cpu_alloc.c	2008-09-30 07:09:09.000000000 -0500
+++ linux-2.6/mm/cpu_alloc.c	2008-09-30 07:10:20.000000000 -0500
@@ -27,8 +27,6 @@
 #define UNIT_TYPE int
 #define UNIT_SIZE sizeof(UNIT_TYPE)

-int units;	/* Actual available units */
-
 /*
  * How many units are needed for an object of a given size
  */
