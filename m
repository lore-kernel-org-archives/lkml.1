Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbXLDJzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbXLDJzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 04:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXLDJy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 04:54:58 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:9510 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbXLDJy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 04:54:56 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] rewrite rd
Date: Tue, 4 Dec 2007 10:54:51 +0100
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
References: <20071204042628.GA26636@wotan.suse.de>
In-Reply-To: <20071204042628.GA26636@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712041054.51599.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 4. Dezember 2007 schrieb Nick Piggin:
[...]
> There is one slight downside -- direct block device access and filesystem
> metadata access goes through an extra copy and gets stored in RAM twice.
> However, this downside is only slight, because the real buffercache of the
> device is now reclaimable (because we're not playing crazy games with it),
> so under memory intensive situations, footprint should effectively be the
> same -- maybe even a slight advantage to the new driver because it can also
> reclaim buffer heads.

This is just an idea, I dont know if it is worth the trouble, but have you
though about implementing direct_access for brd? That would allow 
execute-in-place (xip) on brd eliminating the extra copy.

Christian
