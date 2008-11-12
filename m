Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbYKLDSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbYKLDSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 22:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYKLDR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 22:17:59 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:40607 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYKLDR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 22:17:58 -0500
Date: Tue, 11 Nov 2008 21:17:16 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Mike Travis <travis@sgi.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Takashi Iwai <tiwai@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allocate module.ref array dynamically
In-Reply-To: <491A3EB9.8020203@sgi.com>
Message-ID: <Pine.LNX.4.64.0811112115090.10592@quilx.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <491A01E2.2010701@cosmosbay.com>
 <200811121214.33150.rusty@rustcorp.com.au> <491A3EB9.8020203@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Mike Travis wrote:

> I haven't looked closely at Christoph's latest but I believe the x86_64 version
> is waiting for the zero-based percpu variables (and hence the combined pda/percpu
> base.)  It's on the queue just under 4k cpus.

The base cpu_alloc is indepedent. And your laziness on the zero based
stuff only hurts the x86_64 version. Frankly, I think we should stop
merging 4k patches until you have finished the work on zero based because
that is elementary for various other things and simplifies 4k work. And it
has been pending for more than 6 months now.


