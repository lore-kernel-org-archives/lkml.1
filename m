Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbXFGHNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbXFGHNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXFGHMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:12:53 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:43010 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbXFGHMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:12:52 -0400
Date: Thu, 7 Jun 2007 16:11:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: mano@roarinelk.homelinux.net
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm2
Message-ID: <20070607071138.GA15420@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	mano@roarinelk.homelinux.net,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070607064231.GQ6909@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607064231.GQ6909@holomorphy.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 11:42:31PM -0700, William Lee Irwin III wrote:
> sound/soc/sh/Kconfig:6:warning: 'select' used by config symbol 'SND_SOC_PCM_SH7760' refers to undefined symbol 'SH_DMABRG'

Manuel, can you take a look at this and fix up the select behaviour? Perhaps
sound/soc/sh/Kconfig should just have a CONFIG_SUPERH around it.
