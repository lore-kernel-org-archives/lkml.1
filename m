Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbYCETti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbYCETti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbYCETta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:49:30 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:58559 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725AbYCETt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:49:29 -0500
Date: Wed, 5 Mar 2008 20:49:22 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
In-Reply-To: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.DEB.1.00.0803052038410.8658@sheep.housecafe.de>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Pavel Machek wrote:
> CommitLimit:   4132360 kB
> Committed_AS:    27684 kB
> VmallocTotal: 34359738367 kB
> VmallocUsed:     18112 kB
> VmallocChunk: 34359720115 kB

out of curiosity: yesterday I've seen a box[0] with ~4 TB Committed_AS:

CommitLimit:   3085152 kB
Committed_AS: 4281048084 kB
VmallocTotal:   118776 kB
VmallocUsed:     13772 kB
VmallocChunk:   103880 kB

Since it's a rather old kernel (2.6.19.2), I just want to know: could this 
be related to what you've seen or this completely different (and 
Committed_AS is just this high because some st00pid app has allocated this 
much memory but not freed again)?

Thanks,
Christian.

[0] amd64, 32bit kernel, 32bit userland, 4GB RAM
-- 
BOFH excuse #101:

Collapsed Backbone
