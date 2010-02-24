Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab0BXKD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:03:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55388 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756265Ab0BXKD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:03:56 -0500
Date: Wed, 24 Feb 2010 10:03:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] Regulators: ab3100 - fix probe and remove
 annotations
Message-ID: <20100224100354.GB18896@rakim.wolfsonmicro.main>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
 <20100224073750.15964.22427.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224073750.15964.22427.stgit@localhost.localdomain>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 11:37:50PM -0800, Dmitry Torokhov wrote:
> Probe and remove methods should not be marked as __init/__exit but
> rather __devinit/__devexit so that the needed sections stay in memory
> in presence of CONFIG_HOTPLUG. This is needed even on non hotpluggable
> buses.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
