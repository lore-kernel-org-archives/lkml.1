Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZFWFzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZFWFzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZFWFzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:55:36 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37340 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751080AbZFWFzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:55:36 -0400
Date: Tue, 23 Jun 2009 00:55:36 -0500
From: Robin Holt <holt@sgi.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
       Haren Myneni <hbabu@us.ibm.com>, kexec@lists.infradead.org
Subject: Re: [PATCH 1/7] ia64, kdump: Mask MCA/INIT on freezing cpus
Message-ID: <20090623055536.GE6865@sgi.com>
References: <4A39E247.4030908@jp.fujitsu.com> <4A39E2CF.80901@jp.fujitsu.com> <20090622134557.GC7084@sgi.com> <4A4022EA.1020506@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4022EA.1020506@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:33:46AM +0900, Hidetoshi Seto wrote:
> Robin Holt wrote:
...
> Do you mean that the 2nd kernel should be able to handle MCA/INIT from its
> boot up?  I guess the word PROM is nearly equal to PAL/SAL firmware, if so
> then I don't think there are good generic interface/procedure could be
> useful here.  Do you have any concrete idea?

No concrete ideas.  Just a really uneasy feeling whenever the INIT
is disabled.

On SGI's ia64 servers, when the INIT is first received, our PROM (PAL/SAL)
records the processors state.  This record remains for the next reset
or for salinfo to transfer to disk.  We can dump all the records in a
format somewhat similar to the output in /var/log/salinfo/decoded.

On more occasions than I could even begin to describe, those records
have helped us determine what the processor was doing despite it even
ignoring interrupts.  This includes everything except when MCA/INIT
handling is disabled or PMIs are being processed.

If you could give this some consideration, I would appreciate it.
I really don't have the time to dedicate to thinking all the way through
and therefore will not stand in the way of any patch you propose.
If I can be of help in any way, please let me know.

Thanks,
Robin
