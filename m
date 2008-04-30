Return-Path: <linux-kernel-owner+w=401wt.eu-S1762153AbYD3Vto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762153AbYD3Vto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761611AbYD3VtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:49:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53362
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762108AbYD3VtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:49:08 -0400
Date: Wed, 30 Apr 2008 14:49:06 -0700 (PDT)
Message-Id: <20080430.144906.105396672.davem@davemloft.net>
To: greg@kroah.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-git16 fails with "undefined reference to
 `compat_mc_getsockopt'"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080430204622.GA1663@kroah.com>
References: <20080430204622.GA1663@kroah.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Wed, 30 Apr 2008 13:46:22 -0700

> Don't know if you have seen this or not, but 2.6.25-gi16 seems to fail
> with:
> 	net/built-in.o: In function `ipv6_getsockopt':
> 	(.text+0x6829c): undefined reference to `compat_mc_getsockopt'
> 
> I've attached my .config below if that helps any.

Known problem and there is a fix pending, sit tight.
