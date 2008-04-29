Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbYD2S4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbYD2S4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765993AbYD2SzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:55:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765978AbYD2SzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:55:22 -0400
Date: Tue, 29 Apr 2008 11:54:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de
Subject: Re: [PATCH 00/10] Scalability requirements for sysv ipc - v2
Message-Id: <20080429115424.41b82fcb.akpm@linux-foundation.org>
In-Reply-To: <20080429143304.741001000@bull.net>
References: <20080429143304.741001000@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 16:33:04 +0200
Nadia.Derbey@bull.net wrote:

> After scalability problems had been detected when using the sysV ipcs, I
> have proposed to use an RCU based implementation of the IDR api instead
> (see thread http://lkml.org/lkml/2008/4/11/212).
> 
> Resending the patch series after
>  . integrating Paul's remarks
>  . fixing a bug I had introduced
>  . porting it to 2.6.25-mm1.
> 
> Reviewers are still welcome!
> 
> Patch 1 can be taken alone: it fixes a problem in the existing IDR API.
> 
> Patches should be applied on linux-2.6.25-mm1, in the following order:
> 
> [ PATCH 01/10 ] : idr_minor_fix.patch
> [ PATCH 02/10 ] : ridr_structure.patch
> [ PATCH 03/10 ] : ridr_pre_get.patch
> [ PATCH 04/10 ] : ridr_init.patch
> [ PATCH 05/10 ] : ridr_get_new_above.patch
> [ PATCH 06/10 ] : ridr_get_new.patch
> [ PATCH 07/10 ] : ridr_find.patch
> [ PATCH 08/10 ] : ridr_remove.patch
> [ PATCH 09/10 ] : ipc_use_ridr.patch
> [ PATCH 10/10 ] : remove_ipc_lock_down.patch
> 

hm, you've been busy.

As all this work is entirely for performance reasons, the changelog should
have (lots of) performance testing results!  Please.


