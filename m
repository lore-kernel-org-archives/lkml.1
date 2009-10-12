Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbZJLRSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbZJLRSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbZJLRSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:18:08 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:35340 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbZJLRSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:18:07 -0400
Date: Mon, 12 Oct 2009 11:17:29 -0600
From: Alex Chiang <achiang@hp.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] ACPI: dock: add struct dock_station * directly to
	platform device data
Message-ID: <20091012171729.GB8636@ldl.fc.hp.com>
References: <20091007220509.15597.65501.stgit@bob.kio> <20091007220747.15597.90592.stgit@bob.kio> <20091010075230.GA7473@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010075230.GA7473@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

* Shaohua Li <shaohua.li@intel.com>:
> 
> This patch isn't good. platform_device_add_data will malloc a new
> 'struct dock_station' and copy old to it, and later the two copy aren't
> consistent. So NACK this one.

If you can drop this patch without requiring a respin from me, go
ahead.

If you can't, go ahead and drop what you need, and I'll respin.

I'm going to chew on this a bit and see if I can still salvage
it.

> ACK other 5 patches.

Thanks, Shaohua.

/ac

