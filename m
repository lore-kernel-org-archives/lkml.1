Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYJPAdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYJPAdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 20:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbYJPAcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 20:32:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:29512 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbYJPAcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 20:32:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=D1v6IfqUUNYLInO2KDte2tqzI4V0q4ED4hCvqlejBQ4egDNjQkYwwfEJuxmTae7viG
         hxjl85glq2j88s1wHdjCoglZi013ELnh2PwLULBbCj6U1E4RgNSV35fPNq+9un6rCD/j
         bIhLvf1NWG6boThugwbtxYb9ZyMEn02+KayUk=
Subject: Re: [PATCH] sparc64: Annotate pointers in PeeCeeI.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20081015.172351.96225000.davem@davemloft.net>
References: <1224116119.5815.11.camel@brick>
	 <20081015.172351.96225000.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 17:32:51 -0700
Message-Id: <1224117171.5815.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 17:23 -0700, David Miller wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> Date: Wed, 15 Oct 2008 17:15:19 -0700
> 
> > This has no functional changes, but annotates the code to make
> > the endianness more clear.  In addition, removes some of the only
> > users of cpu_to_le[16|32]p in the kernel.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Remind me what the problem is with cpu_to_{le,be}*()?
> 

Nothing inherently wrong with them, other than it seems that nearly
every user (not this one) would be better served using the by-value
versions.

> The interface names define a direction, which in this case is
> "CPU endianness to BE/LE endianness".  And that is exactly
> what is happening in the out*() routines.
> 
> This aids comprehension of the code and is quite useful IMHO.

Yes, and even from that angle I think my patch is more instructive to
understanding the direction, compare for example in the same file
outsw versus outsl which this patch changes.

Harvey



