Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZEVTAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZEVTAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZEVTAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:00:47 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:50267 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZEVTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:00:46 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 May 2009 15:00:46 EDT
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Content-Disposition: inline
From: "Michael S. Zick" <mszick@morethan.org>
Date: Fri, 22 May 2009 13:50:47 -0500
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200905221350.50027.mszick@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 22 2009, you wrote:
> "Michael S. Zick" <lkml@morethan.org> writes:
> 
> > Found in the bit-rot for 32-bit, x86, Uni-processor builds:
> 
> Actually uni processor should not use the lock prefix 
> because it doesn't need it; the only exception are some special
> ops used in para-virtualization which are special cased.
> 

Unless you have interrupts enabled, then you have two contexts.
Only xchg is "naturally" atomic.

Mike
> -Andi
> 


