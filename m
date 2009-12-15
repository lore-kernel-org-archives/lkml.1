Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbZLOXH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbZLOXH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbZLOXHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:07:53 -0500
Received: from smtp-out-139.synserver.de ([212.40.180.139]:1025 "HELO
	smtp-out-135.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1762399AbZLOXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:03:09 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 22078
Date: Wed, 16 Dec 2009 00:02:55 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: kexec boot regression radeon/kms (bisected)
Message-ID: <20091215230255.GA1689@arch.tripp.de>
References: <4B277AB2.8030107@kernel.org>
 <20091215121436.GB28252@kernel.dk>
 <4B2781AC.8020301@kernel.org>
 <20091215123951.GD28252@kernel.dk>
 <4B278734.2040704@kernel.org>
 <20091215141105.GK28252@kernel.dk>
 <4B27D7E9.4030105@kernel.org>
 <20091215185941.GO28252@kernel.dk>
 <4B27DDD7.5040301@kernel.org>
 <20091215213021.GA1735@arch.tripp.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215213021.GA1735@arch.tripp.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 10:30:21PM +0100, Markus Trippelsdorf wrote:

> I have the same symptoms on my machine, but the underlying cause must be
> different. I once reverted all Radeon related changes since 2.6.32 and 
> kexec started working again.
> 
OK, I bisected this down to:

d8f60cfc93452d0554f6a701aa8e3236cbee4636 is the first bad commit
commit d8f60cfc93452d0554f6a701aa8e3236cbee4636
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 1 13:43:46 2009 -0500

    drm/radeon/kms: Add support for interrupts on r6xx/r7xx chips (v3)
-- 
Markus
