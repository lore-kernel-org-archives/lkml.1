Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbXETWZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbXETWZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 18:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbXETWZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 18:25:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:34237 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760129AbXETWZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 18:25:46 -0400
Subject: Re: Badness at include/linux/slub_def.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <Pine.LNX.4.64.0705202304530.14522@sheep.housecafe.de>
References: <Pine.LNX.4.64.0705202304530.14522@sheep.housecafe.de>
Content-Type: text/plain
Date: Mon, 21 May 2007 08:25:36 +1000
Message-Id: <1179699936.32247.572.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-20 at 23:10 +0100, Christian Kujau wrote:
> hi there,
> 
> yet another[0] badness, again from this very iBook running vanilla 
> 2.6.22-rc1-git8:

Just another kmalloc(0)... report this one to the DRI folks, it's not
powerpc specific.

Cheers,
Ben.


