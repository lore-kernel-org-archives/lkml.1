Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbXLHPtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbXLHPtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757842AbXLHPtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:49:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:51508 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583AbXLHPte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:49:34 -0500
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
From: Kay Sievers <kay.sievers@vrfy.org>
To: Bob Tracy <rct@frus.com>
Cc: Michael Cree <mcree@orcon.net.nz>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net,
       ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com
In-Reply-To: <20071208050517.EC35EDBA2@gherkin.frus.com>
References: <20071208050517.EC35EDBA2@gherkin.frus.com>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 16:48:32 +0100
Message-Id: <1197128912.5483.51.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19d34No+QOypyGjvQpkPrg9nv+DjO+FhpFdJmA
 aXDFL5Hy25NLeoDNkwjlCKdyxtrlwhEye+gNvRqSqP+jG98Dhn
 65obObyBNEIBuDoU9lVzhbLDW7YGvRv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-07 at 23:05 -0600, Bob Tracy wrote:
> Kay Sievers wrote:
> > Is the udev daemon (still) running while it fails?
> 
> Yes, and there's something else I forgot to mention that may be
> significant...  For the bad case, in addition to udevd, "ps -ef"
> shows a "sh -e /lib/udev/net.agent" running with a PPID of 1.  This
> process doesn't exit until I reboot.  If this is normal under the
> circumstances, please disregard.

Does SysRq-T show where it hangs?

Kay

