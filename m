Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXGIOZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXGIOZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXGIOZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:25:07 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:40371 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbXGIOZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:25:05 -0400
Message-ID: <46924586.3000808@sw.ru>
Date: Mon, 09 Jul 2007 18:26:14 +0400
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Kirill Korotaev <dev@openvz.org>, devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: jbd lost fix?
References: <468908A9.2010702@openvz.org> <20070709130021.GA30433@duck.suse.cz>
In-Reply-To: <20070709130021.GA30433@duck.suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
>   Hello,
> 
> On Mon 02-07-07 18:16:09, Kirill Korotaev wrote:
> 
>>it looks like the following fix:
>>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=43c3e6f5abdf6acac9b90c86bf03f995bf7d3d92
>>
>>was lost after resurrecting of the spliced checkpointing list in this patch:
>>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=78ce89c92bc6eaf5933b5664bff64253a7103bd7;hp=cdaad343b561cdeb38b0578bb038
>>
>>Can you please confirm that?
> 
>   Sorry for a bit late reply but I was on holiday for a week. Yes, it seems
> like that fix got lost. At least 2.6.22-rc5 still has a wrong test on line
> 890 in commit.c. Thanks for notification, I'll resend it.
>   BTW: How have you found this out?

One of OpenVZ users had an oops at journal_clean_one_cp_list+0x32/0x70
http://bugzilla.openvz.org/show_bug.cgi?id=605

which led us to the lost fix.
Since the patch existed before I didn't dare to resend it from OVZ name :)

Thanks,
Kirill


