Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZDUVzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZDUVzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZDUVy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:54:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:40650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZDUVy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:54:58 -0400
Date: Tue, 21 Apr 2009 21:54:01 +0000
From: Chris Wright <chrisw@sous-sol.org>
To: Tejun Heo <tj@kernel.org>
Cc: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] [PATCH] block: include empty disks in /proc/diskstats
Message-ID: <20090421215401.GA24073@hera.kernel.org>
References: <49E13D18.2090805@solemnwarning.net> <49E440D9.4020803@kernel.org> <49E45079.8070508@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E45079.8070508@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 21:54:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tejun Heo (tj@kernel.org) wrote:
> /proc/diskstats used to show stats for all disks whether they're
> zero-sized or not and their non-zero partitions.  Commit
> 074a7aca7afa6f230104e8e65eba3420263714a5 accidentally changed the
> behavior such that it doesn't print out zero sized disks.  This patch
> implements DISK_PITER_INCL_EMPTY_PART0 flag to partition iterator and
> uses it in diskstats_show() such that empty part0 is shown in
> /proc/diskstats.
> 
> Reported and bisectd by Dianel Collins.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>

looks like this isn't upstream yet.

thanks,
-chris
