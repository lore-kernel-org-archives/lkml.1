Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbYJFTih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbYJFTih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYJFTi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:38:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:21387 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYJFTi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=n+gqbb+FxY+Z9YieR9LuVNZYzsSF8AMfS3T3Kt4ZFzwUzXqPISod4ACLrQ/I1VsRvY
         tIsF7ssG8OUcinxdpBrVqCaghfVayzOuBCCfXZet2D6+cpCMhkv+nCpTcOB5d8t5mZSW
         9iAs2saQvOuCvCcEVUmOxMK5y8maomQzXC45M=
Message-ID: <48EA6929.6030903@gmail.com>
Date: Mon, 06 Oct 2008 21:38:17 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Paul Menage <menage@google.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Marco Innocenti <m.innocenti@cineca.it>,
       matt@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/6] introduce struct res_counter_ratelimit
References: <1221649528-8519-3-git-send-email-righi.andrea@gmail.com> <6599ad830810051103v1bd6e8d4xd2fcf622558fc7d9@mail.gmail.com> <48E9C637.8030507@gmail.com> <6599ad830810061014q5535b5b6kfb53182b3fcc60c8@mail.gmail.com> <48EA48C2.40803@linux.vnet.ibm.com>
In-Reply-To: <48EA48C2.40803@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Paul Menage wrote:
>> On Mon, Oct 6, 2008 at 1:03 AM, Andrea Righi <righi.andrea@gmail.com> wrote:
>>>> Could you not either:
>>>>
>>>> - include these two extra fields in res_counter?
>>>> - include res_counter as the first field in a res_counter_ratelimit?
>>> The second solution would save some space if the "ratelimit" part is not used.
>> Having a "policy" field in res_counter seems like it might be reusable
>> as something for other non-ratelimited res_counters. And even if it's
>> not, the memory overhead of a couple of extra fields in a res_counter
>> is trivial compared to the overhead of resource isolation anyway.
>>
>> So my first approach to this would be just extend res_counter, and
>> then split them apart later if it turns out that they really do need
>> mutually incompatible code/handlers.
> 
> Yes! I agree

Good! I'll go for this.

Thanks,
-Andrea
