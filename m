Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbXGZXaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbXGZXaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbXGZXat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:30:49 -0400
Received: from ozlabs.org ([203.10.76.45]:52486 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbXGZXas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:30:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18089.11934.607569.349144@cargo.ozlabs.ibm.com>
Date: Fri, 27 Jul 2007 09:30:38 +1000
From: Paul Mackerras <paulus@samba.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] make powerpc BUG_ON() OK with pointers and bitwise
In-Reply-To: <E1IE6JZ-0005QA-R8@ZenIV.linux.org.uk>
References: <E1IE6JZ-0005QA-R8@ZenIV.linux.org.uk>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro writes:

> Since powerpc insists on printing the _value_ of condition

We don't _print_ the value of the condition, we give it to a
conditional-trap instruction which will trap if it is non-zero.

> and on casting it to long...  At least let's make it a force-cast.

The long cast is to make sure it's sign-extended to the full register
width.  Adding __force looks fine.

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Paul Mackerras <paulus@samba.org>
