Return-Path: <linux-kernel-owner+w=401wt.eu-S935061AbXGMHdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935061AbXGMHdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbXGMHdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:33:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35005 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbXGMHdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:33:39 -0400
Date: Fri, 13 Jul 2007 00:33:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       andros "@" citi "." umich "." edu <andros@citi.umich.edu>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       J "." Bruce Fields <bfields@puzzle.fieldses.org>,
       Usha Ketineni <ketineni@us.ibm.com>,
       Usha Ketineni <uketinen@us.ibm.com>
Subject: Re: [PATCH 000 of 20] knfsd: Support 'secinfo' exports with related
 cleanups
Message-Id: <20070713003310.2df90a38.akpm@linux-foundation.org>
In-Reply-To: <20070710121949.12548.patches@notabene>
References: <20070710121949.12548.patches@notabene>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 12:22:37 +1000 NeilBrown <neilb@suse.de> wrote:

> With this patchset it becomes possible to list a number of different
> security flavours that maybe used to access an exported filesystem,
> and to attach different export options (e.g. readonly, rootsquash) to
> different flavours.
> Also, NFSv4 can report which flavours are available on a particular export.

Please consider feeding knfsd patches through checkpatch in the future.  It
did find several glitches in these patches which you might have chosen
to address.
