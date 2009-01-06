Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZAFXn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZAFXn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZAFXnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:43:18 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:31261 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZAFXnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:43:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eB94V+8EWwUPvlj48qhPqvbDrGVyERPB9Qbq5dQ2jpuEqA3G+uaha7hanYiYuLmPro
         rSyWjdOQI96/qfQ6Qbzba4ibfg8UdGIKVV2ZjNM3oBscrPfy+GJK/qLN21QkItKEVLlV
         0nxLAHTFUFcmMPpeVmPBGuONOyR+W0K84NntQ=
Subject: Re: [PATCH 14/23] arm: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090106231453.GA3568@flint.arm.linux.org.uk>
References: <1231277452.964.271.camel@brick>
	 <20090106231235.GB20623@flint.arm.linux.org.uk>
	 <20090106231453.GA3568@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 15:42:07 -0800
Message-Id: <1231285327.1529.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 23:14 +0000, Russell King wrote:
> On Tue, Jan 06, 2009 at 11:12:35PM +0000, Russell King wrote:
> > Thanks for bypassing me.
> > 
> > We've had this patch in the kernel before, then it got reverted.
> 
> Correction - we've had something similar to this before.

This got hashed out between HPA, David Woodhouse and I and agreed that
we'd keep the headers exported.

Linus didn't like the conditional byteorder.h and some arches were
already using it.  So I did the sweep of all arches just to get
this over with and move on.  Sorry I didn't give you a heads up
beforehand.

Cheers,

Harvey

