Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab0BLAjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:39:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35273
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757519Ab0BLAjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:39:39 -0500
Date: Thu, 11 Feb 2010 16:39:50 -0800 (PST)
Message-Id: <20100211.163950.206150918.davem@davemloft.net>
To: vapier@gentoo.org
Cc: linux-sh@vger.kernel.org, linux-parisc@vger.kernel.org,
       sparclinux@vger.kernel.org, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: parsic/sh/sparc tracehook breakage when tracing signals
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002111910.50596.vapier@gentoo.org>
References: <201002111910.50596.vapier@gentoo.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 11 Feb 2010 19:10:47 -0500

> when i ported the Blackfin code to the tracehook framework, i copied a latent 
> bug from the sparc port.  trying to trace another process while handling 
> signals no longer worked (and subsequently broke some of the gdb tests).

What you seem to be missing is that on Sparc TIF_SINGLESTEP will never
be set, because it does not support hardware single step.

This thread flag is not even defined on that platform.
