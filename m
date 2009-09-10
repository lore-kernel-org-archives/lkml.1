Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbZIJRIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbZIJRIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 13:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZIJRIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 13:08:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:51392 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZIJRIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 13:08:24 -0400
Subject: Re: linux-next: scsi tree build warnings
From: James Bottomley <James.Bottomley@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Robert Love <robert.w.love@intel.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20090907130024.d67c032d.sfr@canb.auug.org.au>
References: <20090907130024.d67c032d.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 17:08:17 +0000
Message-Id: <1252602497.11956.95.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 13:00 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> usr/include/scsi/fc/fc_els.h:165: found __[us]{8,16,32,64} type without #include <linux/types.h>
> usr/include/scsi/fc/fc_fs.h:32: found __[us]{8,16,32,64} type without #include <linux/types.h>
> usr/include/scsi/fc/fc_gs.h:29: found __[us]{8,16,32,64} type without #include <linux/types.h>
> usr/include/scsi/fc/fc_ns.h:71: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> Introduced by commit 171bb4f9f6a20d405a3cb5111ce92ad83aae2302 ("[SCSI]
> libfc: Export FC headers").

OK, I've dropped this patch ... Robert, can you resubmit it when you've
verified it all works.

James


