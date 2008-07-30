Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYG3Gma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYG3Gma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 02:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYG3GmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 02:42:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35390
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbYG3GmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 02:42:20 -0400
Date: Tue, 29 Jul 2008 23:42:17 -0700 (PDT)
Message-Id: <20080729.234217.93335312.davem@davemloft.net>
To: sfr@au1.ibm.com
Cc: wli@holomorphy.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: merge of_platform_{32,64}.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080730145913.10c124a9.sfr@au.ibm.com>
References: <20080730145913.10c124a9.sfr@au.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@au1.ibm.com>
Date: Wed, 30 Jul 2008 14:59:13 +1000

> The only difference between these files is that the 64 bit version has an
> extra declaration.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

The isa_bus_type is a vestige which I forgot to delete when I
removed the ISA bus layer from sparc and sparc64.  It can be
safely deleted.

I'm going to kill it, then rework your patch to go on top of that.

Thanks!
