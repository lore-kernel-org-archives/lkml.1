Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYHDPrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYHDPrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYHDPr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:47:28 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:34338 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbYHDPr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:47:28 -0400
X-IronPort-AV: E=Sophos;i="4.31,304,1215388800"; 
   d="scan'208";a="1277759"
Date: Mon, 4 Aug 2008 16:47:27 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andreas Schwab <schwab@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext3 seems to ignore ECC errors
Message-ID: <20080804154727.GV4470@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andreas Schwab <schwab@suse.de>, linux-kernel@vger.kernel.org
References: <20080804150353.GS4470@implementation.uk.xensource.com> <je8wvczt5x.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <je8wvczt5x.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 04 Aug 2008 15:47:27.0115 (UTC) FILETIME=[65361DB0:01C8F649]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab, le Mon 04 Aug 2008 17:39:06 +0200, a écrit :
> Samuel Thibault <samuel.thibault@ens-lyon.org> writes:
> > However, to my surprise Linux (2.6.26) continued to mount the ext3
> > filesystem read/write, spitting out a lot of IDE errors.  Shouldn't
> > filesystems remount read-only and let the admin try to save data in such
> > case?
> 
> That's a tunable parameter of the filesystem, see tune2fs(8).

Oh, I had assumed it was on by default, hum.  But now it reads

Errors behavior:          Remount read-only

and I am still getting the same behavior.  Indeed after some VFS
modifications time it gets remounted read-only, but shouldn't that
happen as soon as possible?

Samuel
