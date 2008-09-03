Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYICLjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYICLjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 07:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbYICLjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 07:39:37 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3872 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYICLjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:39:37 -0400
Date: Wed, 3 Sep 2008 13:39:30 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] m68k: Add missing dma_sync_single_range_for_{cpu,
 device}()
In-Reply-To: <Pine.LNX.4.64.0809031322110.11672@anakin>
Message-ID: <Pine.LNX.4.64.0809031337460.7824@localhost.localdomain>
References: <20080903071542.615137611@mail.of.borg> <20080903071742.932797091@mail.of.borg>
 <Pine.LNX.4.64.0809031257080.25157@localhost.localdomain>
 <Pine.LNX.4.64.0809031316450.11672@anakin> <Pine.LNX.4.64.0809031322110.11672@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 3 Sep 2008, Geert Uytterhoeven wrote:

> > IIRC, gcc actually complained about it. I'll check again...
> 
> | arch/m68k/include/asm/dma-mapping.h:73: warning: 'dma_sync_single_for_device' declared inline after being called
> | arch/m68k/include/asm/dma-mapping.h:73: warning: previous declaration of 'dma_sync_single_for_device' was here

In the same patch you've also added that user, simply don't inline that 
function. :)

bye, Roman
