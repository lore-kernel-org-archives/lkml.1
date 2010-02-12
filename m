Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab0BLCIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 21:08:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:47056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757781Ab0BLCIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 21:08:47 -0500
Message-ID: <4B74B9E5.60708@kernel.org>
Date: Fri, 12 Feb 2010 11:16:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <gregkh@suse.de>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
References: <19314.1869.847327.15190@notabene.brown>	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>	<4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org>	<4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>	<20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org>	<4B73671E.2050105@kernel.org> <m1mxzfzlv3.fsf@fess.ebiederm.org>	<4B74A7F3.9000001@kernel.org> <m1r5oruu4m.fsf@fess.ebiederm.org>
In-Reply-To: <m1r5oruu4m.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Feb 2010 02:08:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/12/2010 10:20 AM, Eric W. Biederman wrote:
> My reasoning is that we effectively get an active reference on directories
> for free because we have to delete the children before we can delete a
> directory.

Yeah, as long as we guarantee that all children are removed before the
parent, I think we're in the clear.  The group handling seems
problematic (w/ or w/o the patch) but yeap Ack on removing
get_active_two.

Thanks.

-- 
tejun
