Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYICK73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYICK73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYICK7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:59:19 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3777 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYICK7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:59:18 -0400
Date: Wed, 3 Sep 2008 12:59:04 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] m68k: Add missing dma_sync_single_range_for_{cpu,device}()
In-Reply-To: <20080903071742.932797091@mail.of.borg>
Message-ID: <Pine.LNX.4.64.0809031257080.25157@localhost.localdomain>
References: <20080903071542.615137611@mail.of.borg> <20080903071742.932797091@mail.of.borg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 3 Sep 2008, Geert Uytterhoeven wrote:

> Add the missing dma_sync_single_range_for_{cpu,device}(), and remove the bogus
> `inline' for the non-static function dma_sync_single_for_device().

It's not bogus, it's a hint to gcc to inline the function into the callers 
in the same file, but also to provide an external version.

bye, Roman
