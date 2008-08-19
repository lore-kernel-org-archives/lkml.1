Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbYHSXAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbYHSXAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYHSXAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:00:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58262
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1749667AbYHSXAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:00:30 -0400
Date: Tue, 19 Aug 2008 16:00:27 -0700 (PDT)
Message-Id: <20080819.160027.199401195.davem@davemloft.net>
To: bunk@kernel.org
Cc: fransmeulenbroeks@gmail.com, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: openpromfs; CONFIG_SUN_OPENPROMFS; used ?? or orphaned??
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080819134609.GC8852@cs181140183.pp.htv.fi>
References: <ac9c93b10808190643yc7f9f1dtaf69bff474560e9@mail.gmail.com>
	<20080819134609.GC8852@cs181140183.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Tue, 19 Aug 2008 16:46:10 +0300

> On Tue, Aug 19, 2008 at 03:43:22PM +0200, Frans Meulenbroeks wrote:
> > While roaming through the fs tree I bumped upon the directory openpromfs
> > 
> > Is this one orphaned?
> > I saw that the Makefile references CONFIG_SUN_OPENPROMFS, but I could not find
> > it in a Kconfig file
> >...
> 
> $ grep -r SUN_OPENPROMFS *
> arch/sparc/Kconfig:config SUN_OPENPROMFS
> ...

Yep, only sparc and sparc64 provide this setting.
