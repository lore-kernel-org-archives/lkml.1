Return-Path: <linux-kernel-owner+w=401wt.eu-S1763223AbXFEIvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763223AbXFEIvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761905AbXFEIvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:51:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:35634 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbXFEIvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:51:43 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bugfix GFP_KERNEL -> GFP_ATOMIC in spin_locked region
Date: Tue, 5 Jun 2007 10:51:39 +0200
User-Agent: KMail/1.9.1
Cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@lists.osdl.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-scsi@vger.kernel.org, Seokmann Ju <seokmann.ju@lsil.com>,
       Sumant Patro <sumant.patro@lsi.com>,
       linux-usb-devel@lists.sourceforge.net
References: <87odjvu1on.fsf@wanadoo.fr> <20070604210018.0eaa20a0.akpm@linux-foundation.org> <20070604210824.dfb7c2d9.akpm@linux-foundation.org>
In-Reply-To: <20070604210824.dfb7c2d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706051051.40016.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 5. Juni 2007 06:08 schrieb Andrew Morton:
> Everything in USB appears to already be fixed, apart from the io_ti.c bug.

Yes, that's a bug. I've queued a patch.

	Regards
		Oliver
