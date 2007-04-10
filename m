Return-Path: <linux-kernel-owner+w=401wt.eu-S1031003AbXDJQLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031003AbXDJQLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030932AbXDJQLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:11:42 -0400
Received: from ns.suse.de ([195.135.220.2]:52626 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031003AbXDJQLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:11:41 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup compat ioctl handling
References: <20070410112857.GA4581@lst.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 Apr 2007 19:10:02 +0200
In-Reply-To: <20070410112857.GA4581@lst.de>
Message-ID: <p73fy78jgut.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Merge all compat ioctl handling into compat_ioctl.c instead of splitting
> it over compat.c and compat_ioctl.c.  This also allows to get rid of
> ioctl32.h

Looks good. 

If someone feels the need to do more cleanup here -- it would be also
nice to move more handlers to be in ->compat_ioctl and in their respective
files than so much compat_ioctl.

-Andi
