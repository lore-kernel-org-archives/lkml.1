Return-Path: <linux-kernel-owner+w=401wt.eu-S935316AbZJOSpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316AbZJOSpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935289AbZJOSpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:45:14 -0400
Received: from kroah.org ([198.145.64.141]:60257 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935281AbZJOSpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:45:13 -0400
Date: Thu, 15 Oct 2009 11:29:06 -0700
From: Greg KH <greg@kroah.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com
Subject: Re: [PATCH 0/7] SECURITY ISSUE with connector for 2.6.31.y
Message-ID: <20091015182906.GB3921@kroah.com>
References: <20091009222505.GA28979@kroah.com>
 <1255426098-9411-1-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255426098-9411-1-git-send-email-philipp.reisner@linbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 11:28:11AM +0200, Philipp Reisner wrote:
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

All queued up, thanks.

greg k-h
