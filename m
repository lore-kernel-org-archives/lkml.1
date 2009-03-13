Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbZCMHWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbZCMHWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZCMHV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:21:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:46030 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbZCMHV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:21:57 -0400
Date: Fri, 13 Mar 2009 16:21:06 +0900 (JST)
Message-Id: <20090313.162106.72987812.ryusuke@osrg.net>
To: akpm@linux-foundation.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, hch@lst.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Asking for inclusion of nilfs2 in the mainline kernel
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20090311.173548.59681981.ryusuke@osrg.net>
References: <20090311.015542.118514963.ryusuke@osrg.net>
	<20090310155459.11ffa81f.akpm@linux-foundation.org>
	<20090311.173548.59681981.ryusuke@osrg.net>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 13 Mar 2009 16:21:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 17:35:48 +0900 (JST), Ryusuke Konishi wrote:
> On Tue, 10 Mar 2009 15:54:59 -0700, Andrew Morton wrote:
> > Also..  Don't get _too_ concerned about freezing the on-disk format at
> > this time.  You could put in a mount-time printk("the nilfs on-disk
> > format may change at any time - do not place critical data on a nilfs
> > filesystem") and we leave that in place for a few months while things
> > stabilise.
> 
> Got it.  So, I will do the message insertion  :)

I've done this in the mount helper program of nilfs2.

Regards,
Ryusuke
