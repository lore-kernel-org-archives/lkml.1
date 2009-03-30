Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZC3ARo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZC3ARo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 20:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZC3ARf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 20:17:35 -0400
Received: from ozlabs.org ([203.10.76.45]:34644 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbZC3ARe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 20:17:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] oprofile: Thou shalt not call __exit functions from __init functions
Date: Mon, 30 Mar 2009 10:47:27 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
References: <20090329161222.GA3601@flint.arm.linux.org.uk>
In-Reply-To: <20090329161222.GA3601@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903301047.27887.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009 02:42:22 Russell King wrote:
> `buffer_sync_cleanup' referenced in section `.init.text' of arch/arm/oprofile/built-in.o: defined in discarded section `.exit.text' of arch/arm/oprofile/built-in.o
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks, I've applied it in case the oprofile people don't get there first.

Cheers,
Rusty.
