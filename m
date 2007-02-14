Return-Path: <linux-kernel-owner+w=401wt.eu-S932188AbXBNImq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbXBNImq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932187AbXBNImq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:42:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:36204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181AbXBNImp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:42:45 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] Fix d_path for lazy unmounts
Date: Wed, 14 Feb 2007 00:42:38 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Al Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Tony Jones <tonyj@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@lst.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, walt <wa1ter@myrealbox.com>
References: <200702021923.02491.agruen@suse.de> <200702140019.36378.agruen@suse.de> <20070214082941.GA8191@aepfle.de>
In-Reply-To: <20070214082941.GA8191@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702140042.38567.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 00:29, Olaf Hering wrote:
> On Wed, Feb 14, Andreas Gruenbacher wrote:
> > What's the point in reporting the rootfs at all -- it's never reachable
> > to an ordinary process?
>
> /init and its childs has it as root, until it passes control over to
> /sbin/init

Yes, that's why I said "ordinary".
