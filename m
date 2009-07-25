Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZGYFod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZGYFod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 01:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZGYFoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 01:44:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:40638 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZGYFoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 01:44:32 -0400
Date: Fri, 24 Jul 2009 22:31:07 -0700
From: Greg KH <greg@kroah.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/19] ceph: debugfs
Message-ID: <20090725053107.GA20575@kroah.com>
References: <1248292313-31326-10-git-send-email-sage@newdream.net>
 <1248292313-31326-11-git-send-email-sage@newdream.net>
 <1248292313-31326-12-git-send-email-sage@newdream.net>
 <1248292313-31326-13-git-send-email-sage@newdream.net>
 <1248292313-31326-14-git-send-email-sage@newdream.net>
 <1248292313-31326-15-git-send-email-sage@newdream.net>
 <1248292313-31326-16-git-send-email-sage@newdream.net>
 <1248292313-31326-17-git-send-email-sage@newdream.net>
 <1248292313-31326-18-git-send-email-sage@newdream.net>
 <1248292313-31326-19-git-send-email-sage@newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248292313-31326-19-git-send-email-sage@newdream.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 12:51:52PM -0700, Sage Weil wrote:
> Basic state information is available via /debug/ceph, including
> instances of the client, fsids, current monitor, mds and osd maps,
> outstanding server requests, and hooks to adjust debug levels.

debugfs is to be mounted at /sys/kernel/debug, not /debug  Please don't
add any documentation or comments referring debugfs at /debug, we have
just finally cleaned up all of these instances in the kernel right now.

thanks,

greg k-h
