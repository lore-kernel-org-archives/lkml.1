Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYGDS7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYGDS7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 14:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYGDS70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 14:59:26 -0400
Received: from wasp.net.au ([203.190.192.17]:38649 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYGDS7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 14:59:25 -0400
Message-ID: <486E7307.8040809@wasp.net.au>
Date: Fri, 04 Jul 2008 22:59:19 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc8-git3 forcedeth WARNING (kills the interface)
References: <486CA4EB.1040804@wasp.net.au>
In-Reply-To: <486CA4EB.1040804@wasp.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brad Campbell wrote:
> G'day all,
> Same problem I reported in -rc7.
> 
> This is a vanilla kernel with the addition of the imq and adt7475 
> modules. imq is not relevant here as I only added it this morning and 
> this has been going on all week.
> 

I've tested without the adt7475 and i2c-nForce2 module today after a clean boot. No Difference.

On advice recompiled with CONFIG_FORCEDETH_NAPI disabled and "modprobe forcedeth msi=0 msix=0". It 
died within 5 minutes with the same symptoms. Is there anything else anyone can recommend to test?

Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
