Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZDMFf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZDMFf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 01:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZDMFfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 01:35:20 -0400
Received: from night.yars.free.net ([193.233.48.54]:57039 "EHLO
	night.yars.free.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbZDMFfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 01:35:19 -0400
X-Greylist: delayed 2417 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2009 01:35:18 EDT
Date: Mon, 13 Apr 2009 08:54:52 +0400
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1 vs 2.6.27.21 ext4 performance problem
Message-ID: <20090413045452.GA16038@night.netis.ru>
References: <20090410151235.GA9690@proxy> <20090410163620.GA14814@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410163620.GA14814@mit.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 12:36:20PM -0400, Theodore Tso wrote:
> Does the differences go away if you do echo 0 into
> /sys/fs/ext4/<dev>/inode_readahead_blks?

Yes! Thanks for the tip. I think the problem here is that there
are lots of files (2M per file system) and the access is random.

> Are you seeing an increase in time, or decrease in transactions per
> second, or just that there is is an increase in read rates?

Load average goes up from 6 to 30, and request latency increases.

-- 
   Alexander..
