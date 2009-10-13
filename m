Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbZJMQml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbZJMQml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZJMQmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:42:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46463 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZJMQmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:42:40 -0400
Date: Tue, 13 Oct 2009 11:25:09 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] SECURITY ISSUE with connector for 2.6.31.y
Message-ID: <20091013162509.GA11409@us.ibm.com>
References: <20091009222505.GA28979@kroah.com> <1255426098-9411-1-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255426098-9411-1-git-send-email-philipp.reisner@linbit.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Philipp Reisner (philipp.reisner@linbit.com):
> The backported edition of the patchset for 2.6.31-stable.
> 
> Philipp Reisner (7):
>   connector: Keep the skb in cn_callback_data
>   connector: Provide the sender's credentials to the callback
>   connector: Removed the destruct_data callback since it is always
>     kfree_skb()
>   dm/connector: Only process connector packages from privileged
>     processes
>   dst/connector: Disallow unpliviged users to configure dst
>   pohmelfs/connector: Disallow unpliviged users to configure pohmelfs
>   uvesafb/connector: Disallow unpliviged users to send netlink packets

Thanks Philipp, I see it's already applied upstream, but it looks good to me.
Does drivers/w1/w1_netlink.c or drivers/connector/cn_proc.c need a caps check
added as well?

thanks,
-serge
