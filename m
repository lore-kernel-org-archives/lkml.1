Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZCTFrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZCTFrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 01:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZCTFrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 01:47:42 -0400
Received: from kroah.org ([198.145.64.141]:50661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750836AbZCTFrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 01:47:41 -0400
Date: Thu, 19 Mar 2009 22:44:37 -0700
From: Greg KH <greg@kroah.com>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #3 2/2] split 'xino' entry under sysfs
Message-ID: <20090320054437.GC3993@kroah.com>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp> <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp> <20090320004539.GF18781@kroah.com> <3934.1237515949@jrobl> <20090320024249.GA19989@kroah.com> <4443.1237517709@jrobl> <20090320030608.GA2638@kroah.com> <5142.1237521581@jrobl> <20090320041811.GA3352@kroah.com> <6218.1237526149@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6218.1237526149@jrobl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 02:15:49PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Greg KH:
> > Looks like a good start, if you are _sure_ you need sysfs files :)
> 
> I believe those paths are important to users.
> When CONFIG_SYSFS is disabled, they are printed in /proc/mounts (and has
> severer limit).

No one disables sysfs that I know of.  Heck, my phone enables sysfs...

> Addition to set limit, there is one more reason to adopt seq_file.
> Because the printed string is a path, it may contain unprintable
> characters. seq_file has a good interface seq_path() which supports
> escaping such characters.

That is true.  Ok, let's see the final result and I'll be glad to look
at it.

thanks,

greg k-h
