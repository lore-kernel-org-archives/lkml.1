Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbZG1Hxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbZG1Hxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZG1Hxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:53:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59763 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZG1Hxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:53:45 -0400
Message-ID: <4A6EAE87.9020006@cs.helsinki.fi>
Date: Tue, 28 Jul 2009 10:53:43 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [patch] slub: use size and objsize orders to disable debug flags
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.Pi.BZObKB@chimera> <4A6CF220.7080605@lwfinger.net> <alpine.DEB.2.00.0907261722140.21259@chino.kir.corp.google.com> <84144f020907270008h2a985278of68e70ff1ee9265c@mail.gmail.com> <alpine.DEB.2.00.0907270227420.15760@chino.kir.corp.google.com> <alpine.DEB.1.10.0907271320130.13513@gentwo.org> <alpine.DEB.2.00.0907271113460.8408@chino.kir.corp.google.com> <alpine.DEB.1.10.0907271740090.27697@gentwo.org> <alpine.DEB.2.00.0907271533070.23587@chino.kir.corp.google.com> <alpine.DEB.2.00.0907271830010.7634@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0907271830010.7634@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> This patch moves the masking of debugging flags which increase a cache's
> min order due to metadata when `slub_debug=O' is used from
> kmem_cache_flags() to kmem_cache_open().
> 
> Instead of defining the maximum metadata size increase in a preprocessor
> macro, this approach uses the cache's ->size and ->objsize members to
> determine if the min order increased due to debugging options.  If so,
> the flags specified in the more appropriately named DEBUG_METADATA_FLAGS
> are masked off.
> 
> This approach was suggested by Christoph Lameter
> <cl@linux-foundation.org>.
> 
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Applied, thanks!
