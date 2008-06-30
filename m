Return-Path: <linux-kernel-owner+w=401wt.eu-S1762353AbYF3RlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762353AbYF3RlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759146AbYF3Rkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:40:52 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:39186 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbYF3Rkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:40:51 -0400
Message-ID: <48691AA2.7050201@oracle.com>
Date: Mon, 30 Jun 2008 10:40:50 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Nikanth Karthikesan <knikanth@suse.de>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH]  aio: remove unused function aio_run_iocbs()
References: <200806261640.27048.knikanth@suse.de> <x49lk0rt3x6.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49lk0rt3x6.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
> Nikanth Karthikesan <knikanth@suse.de> writes:
> 
>> remove unused function aio_run_iocbs()
> 
> Seems like it's time to just get rid of it.  See:
>   http://ussg.iu.edu/hypermail/linux/kernel/0608.0/0048.html
> for an explanation of why it's still there.

Yeah, I'm still of the opinion that the cost of having to resurrect it
if it's needed again isn't significant enough to keep it in the tree
without callers.

- z
