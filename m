Return-Path: <linux-kernel-owner+w=401wt.eu-S965724AbXCGXES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724AbXCGXES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945910AbXCGXES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:04:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36647 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945897AbXCGXEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:04:16 -0500
Date: Wed, 7 Mar 2007 15:00:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2: drivers/net/wireless/libertas/debugfs.c addr
 bogosity
Message-Id: <20070307150057.4e6342dc.akpm@linux-foundation.org>
In-Reply-To: <20070307224116.GE3441@stusta.de>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	<20070307224116.GE3441@stusta.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 23:41:16 +0100
Adrian Bunk <bunk@stusta.de> wrote:

> On Tue, Mar 06, 2007 at 12:44:08AM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.20-rc2-mm1:
> >...
> >  git-netdev-all.patch
> >...
> >  git trees
> >...
> 
> drivers/net/wireless/libertas/debugfs.c contains:
>   #define item_addr(n) ((u32) &((wlan_adapter *)0)->n)
> 
> This is wrong on 64bit architectures.

Is OK - it is simply yet another reimplementation of offsetof().  Hint.
