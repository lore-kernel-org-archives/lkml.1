Return-Path: <linux-kernel-owner+w=401wt.eu-S1762923AbZAGXHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762923AbZAGXHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZAGXHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:07:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38298
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbZAGXHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:07:11 -0500
Date: Wed, 07 Jan 2009 15:07:12 -0800 (PST)
Message-Id: <20090107.150712.27763774.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: rmk+kernel@arm.linux.org.uk, adobriyan@gmail.com,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: hardirq.h removal broke sparc64 build...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090107145822.625960f2.akpm@linux-foundation.org>
References: <20090107.144310.79937111.davem@davemloft.net>
	<20090107145822.625960f2.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 7 Jan 2009 14:58:22 -0800

> On Wed, 07 Jan 2009 14:43:10 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> > for the drivers/base/topology.o build failure case above.
> 
> yes, there were some nasty problems liek that.  In several cases we wimped
> out and added the necessary includes to the .c file.  Will that (sad hack)
> work here?

I'll try that but if other gremlins pop up I'll simply
add a linux/hardirq.h include to arch/sparc/include/asm/local.h
