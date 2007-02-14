Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXBNI3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXBNI3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932168AbXBNI3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:29:36 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:37726 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151AbXBNI3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:29:36 -0500
Date: Wed, 14 Feb 2007 09:29:41 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Al Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Tony Jones <tonyj@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@lst.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, walt <wa1ter@myrealbox.com>
Subject: Re: [PATCH] Fix d_path for lazy unmounts
Message-ID: <20070214082941.GA8191@aepfle.de>
References: <200702021923.02491.agruen@suse.de> <200702050032.06905.agruen@suse.de> <200702140019.36378.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200702140019.36378.agruen@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, Andreas Gruenbacher wrote:

> What's the point in reporting the rootfs at all -- it's never reachable to an 
> ordinary process?

/init and its childs has it as root, until it passes control over to
/sbin/init
