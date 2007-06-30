Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbXF3J3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbXF3J3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXF3J3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:29:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40474 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbXF3J3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:29:35 -0400
Date: Sat, 30 Jun 2007 10:29:34 +0100
From: Christoph Hellwig <hch@infradead.org>
To: jjohansen@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 01/44] Pass struct vfsmount to the inode_create LSM hook
Message-ID: <20070630092934.GA22354@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, jjohansen@suse.de,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
	Andreas Gruenbacher <agruen@suse.de>
References: <20070626230756.519733902@suse.de> <20070626230851.325388038@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626230851.325388038@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 04:07:57PM -0700, jjohansen@suse.de wrote:
> This is needed for computing pathnames in the AppArmor LSM.

Please see the various per-mountpoint r/o thread that NACKed all the
vfsmount additions and have the rationale for it.

