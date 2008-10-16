Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYJPAYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYJPAYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 20:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbYJPAYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 20:24:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50353
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753469AbYJPAYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 20:24:15 -0400
Date: Wed, 15 Oct 2008 17:23:51 -0700 (PDT)
Message-Id: <20081015.172351.96225000.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] sparc64: Annotate pointers in PeeCeeI.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1224116119.5815.11.camel@brick>
References: <1224116119.5815.11.camel@brick>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Wed, 15 Oct 2008 17:15:19 -0700

> This has no functional changes, but annotates the code to make
> the endianness more clear.  In addition, removes some of the only
> users of cpu_to_le[16|32]p in the kernel.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Remind me what the problem is with cpu_to_{le,be}*()?

The interface names define a direction, which in this case is
"CPU endianness to BE/LE endianness".  And that is exactly
what is happening in the out*() routines.

This aids comprehension of the code and is quite useful IMHO.
