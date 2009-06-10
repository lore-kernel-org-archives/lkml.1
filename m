Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbZFJIJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbZFJIJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZFJIJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:09:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51050
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755511AbZFJIJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:09:13 -0400
Date: Wed, 10 Jun 2009 01:09:15 -0700 (PDT)
Message-Id: <20090610.010915.255287284.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, jdike@addtoit.com,
       hch@infradead.org, mingo@elte.hu, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [Patch 4/5] module: trim exception table in module_free()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906060038.03089.rusty@rustcorp.com.au>
References: <200906041800.54696.rusty@rustcorp.com.au>
	<4A278C62.8000801@redhat.com>
	<200906060038.03089.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 6 Jun 2009 00:38:02 +0930

> Sparc32 is unique; it doesn't seem to define ARCH_HAS_SORT_EXTABLE,
> yet it defines its own sort_extable() which overrides the one in lib.
> It doesn't sort, so we have to mark deleted entries instead of
> actually trimming them.
> 
> Inspired-by: Amerigo Wang <amwang@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: David S. Miller <davem@davemloft.net>
