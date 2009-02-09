Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZBIJdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZBIJdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZBIJdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:33:46 -0500
Received: from ozlabs.org ([203.10.76.45]:43374 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZBIJdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:33:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] module_param: bool params should still work with #include <stdbool.h>
Date: Mon, 9 Feb 2009 20:03:39 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Arjan van de Ven <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902092003.39875.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009 18:22:26 Rusty Russell wrote:
> 
> Code such as "module_param(foo, bool, 0400)" no longer compiles if one
> includes stdbool.h: the ISO standard requires that this "#define bool
> _Bool".

Of course, better fix is not to use stdbool.h, but leave it to the
typedef in kernel/types.h.

Forget this patch...
Rusty.
