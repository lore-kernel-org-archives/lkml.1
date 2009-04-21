Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZDUAsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZDUAsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 20:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbZDUAsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 20:48:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48206 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbZDUAsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 20:48:01 -0400
Date: Tue, 21 Apr 2009 01:47:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andreas Dilger <adilger@sun.com>
Cc: Michal Simek <michal.simek@petalogix.com>,
       Nate Straz <nate-ltp@refried.org>, subrata@linux.vnet.ibm.com,
       ltp-list@lists.sourceforge.net,
       John Williams <john.williams@petalogix.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [LTP] statvfs -> f_bavail
Message-ID: <20090421004757.GC8633@ZenIV.linux.org.uk>
References: <49E759FB.70103@petalogix.com> <49E847FB.1030801@petalogix.com> <20090417173107.GA3590@refried.org> <49EC1352.6010900@petalogix.com> <20090420062642.GY26366@ZenIV.linux.org.uk> <49EC1945.1000805@petalogix.com> <20090421002503.GA8633@ZenIV.linux.org.uk> <20090421003847.GO3209@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421003847.GO3209@webber.adilger.int>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 06:38:47PM -0600, Andreas Dilger wrote:
> On Apr 21, 2009  01:25 +0100, Al Viro wrote:
> > 	a) ramfs has no such thing as "amount of available space", simply
> > because it has no limit on total size occupied.
> 
> Well, except the amount of RAM in the system, which would be a reasonable
> value to use.

You are welcome to provide an analysis of differences between the moments
when OOM hits root and non-root resp. if they keep allocating there...
