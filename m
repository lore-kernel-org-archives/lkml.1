Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbXGIMpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbXGIMpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXGIMpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:45:21 -0400
Received: from styx.suse.cz ([82.119.242.94]:53877 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753049AbXGIMpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:45:19 -0400
Date: Mon, 9 Jul 2007 15:00:21 +0200
From: Jan Kara <jack@suse.cz>
To: Kirill Korotaev <dev@openvz.org>
Cc: devel@openvz.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: jbd lost fix?
Message-ID: <20070709130021.GA30433@duck.suse.cz>
References: <468908A9.2010702@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468908A9.2010702@openvz.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Mon 02-07-07 18:16:09, Kirill Korotaev wrote:
> it looks like the following fix:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=43c3e6f5abdf6acac9b90c86bf03f995bf7d3d92
> 
> was lost after resurrecting of the spliced checkpointing list in this patch:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=78ce89c92bc6eaf5933b5664bff64253a7103bd7;hp=cdaad343b561cdeb38b0578bb038
> 
> Can you please confirm that?
  Sorry for a bit late reply but I was on holiday for a week. Yes, it seems
like that fix got lost. At least 2.6.22-rc5 still has a wrong test on line
890 in commit.c. Thanks for notification, I'll resend it.
  BTW: How have you found this out?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
