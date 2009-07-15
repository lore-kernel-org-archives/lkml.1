Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZGOKcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZGOKcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZGOKcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:32:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59825 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752089AbZGOKcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:32:06 -0400
Date: Wed, 15 Jul 2009 11:32:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sound/soc/codecs/wm9081.c compiler warning
Message-ID: <20090715103202.GB27594@rakim.wolfsonmicro.main>
References: <1247639434.2437.14.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1247639434.2437.14.camel@ht.satnam>
X-Cookie: 42
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 12:00:34PM +0530, Jaswinder Singh Rajput wrote:

>   CC [M]  sound/soc/codecs/wm9081.o
> sound/soc/codecs/wm9081.c: In function ‘configure_clock’:
> sound/soc/codecs/wm9081.c:674: warning: ‘new_sysclk’ may be used uninitialized in this function
> 
> This fixes the warning in my case, hope this will be helpful :

I've pushed an alternative patch which hopefully fixes this (none of my
compilers appear to generate the warning so I can't check that the
warning is gone).
