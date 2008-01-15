Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYAONQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYAONQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYAONQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:16:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60186 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYAONQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:16:45 -0500
Date: Tue, 15 Jan 2008 13:16:40 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Abhishek Rai <abhishekrai@google.com>, linux-kernel@vger.kernel.org,
       rohitseth@google.com, linux-ext4@vger.kernel.org
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm
	patch]
Message-ID: <20080115131640.GB5766@infradead.org>
References: <200801140839.01986.abhishekrai@google.com> <20080114163412.83a8b18d.akpm@linux-foundation.org> <20080115030441.a0270609.akpm@linux-foundation.org> <20080115131533.GA5766@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115131533.GA5766@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 01:15:33PM +0000, Christoph Hellwig wrote:
> They won't fsck in planned downtimes.  They will have to use fsck when
> the shit hits the fan and they need to.   Not sure about ext3, but big
> XFS user with a close tie to the US goverment were concerned about this
> case for really big filesystems and have sponsored speedup including
> multithreading xfs_repair.  I'm pretty sure the same arguments apply
> to ext3, even if the filesystems are a few magnitudes smaller.

And to add to that thanks to the not quite optimal default of
peridocially checking that I alwasy forget to turn off on test machines
an ext3 fsck speedup would be in my personal interested, and probably
that of tons of developers :)
