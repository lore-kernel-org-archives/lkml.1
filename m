Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbXDMM27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbXDMM27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbXDMM27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:28:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59145 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbXDMM27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:28:59 -0400
Date: Fri, 13 Apr 2007 13:28:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: greg@uclinux.org, michele.damico@fitre.it, linux-kernel@vger.kernel.org
Subject: Re: [patch] dont force uclinux mtd map to be root dev
Message-ID: <20070413122843.GA30232@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mike Frysinger <vapier@gentoo.org>, greg@uclinux.org,
	michele.damico@fitre.it, linux-kernel@vger.kernel.org
References: <200704130819.32657.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704130819.32657.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 08:19:31AM -0400, Mike Frysinger wrote:
> the cheesy uclinux mtd maps can be used for more than just the root device, so 
> i think we should drop the forcing.  also, i feel like this is a policy 
> decision that shouldnt be in the kernel in the first place.  people who have 
> been lazy and boot with uclinux mtd maps and dont put root= into their 
> commandline can simply add the appropriate root= line either into their 
> bootloader or into the compiled in bootargs

Agreed.  I remember trying to get rid of this a while ago, but I can't
remember what happened to it.

