Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbZGASN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbZGASN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZGASNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:13:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:52029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZGASNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:13:12 -0400
Message-ID: <4A4BA71C.8000509@kernel.org>
Date: Wed, 01 Jul 2009 11:12:44 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: alex.shi@intel.com
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Chen, Tim C" <tim.c.chen@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [patch] fix hugepage unuseable issu on non-NUMA machine
References: <1246273802.3160.28.camel@alexs-hp>	 <4A48F377.3020008@kernel.org> <1246441138.3042.18.camel@alexs-hp>
In-Reply-To: <1246441138.3042.18.camel@alexs-hp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Shi wrote:
> I have tried your patch. the specjbb2005 still can not run with the
> following parameters under jrockit-R27.3.1-jre1.5.0_11 and with totla
> 2GB hugepage memory setting. 
> JAVA_OPTION= -Xmx2g -Xms2g -Xns1g -XXaggressive -Xlargepages -XXlazyUnlocking -Xgc:genpar -XXtlasize:min=16k,preferred=64k  -Djava.awt.headless=true

can you send out .config and bootlog?

YH
