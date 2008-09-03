Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYICMgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYICMgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYICMgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:36:11 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4757 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYICMgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:36:11 -0400
Date: Wed, 3 Sep 2008 14:36:00 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Adrian Bunk <bunk@kernel.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] m68k: Add missing dma_sync_single_range_for_{cpu,device}()
In-Reply-To: <20080903121220.GF4104@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0809031429520.7824@localhost.localdomain>
References: <20080903071542.615137611@mail.of.borg> <20080903071742.932797091@mail.of.borg>
 <Pine.LNX.4.64.0809031257080.25157@localhost.localdomain>
 <20080903121220.GF4104@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 3 Sep 2008, Adrian Bunk wrote:

> either we want it inlined into all callers or we want one external copy.
> Doing both is suboptimal.

Not so much in this case, usually only a subset of these functions is 
used, so the actual worker functions have the expanded version, but they
aren't inlined themselves.
You could create a separate "static inline" function and use that there, 
but the result should be the same.

bye, Roman
