Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab0BJIDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 03:03:45 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44894 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab0BJIDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 03:03:44 -0500
To: Tejun Heo <tj@kernel.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Neil Brown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
References: <19314.1869.847327.15190@notabene.brown>
	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>
	<4B7217CF.2080702@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 10 Feb 2010 00:03:38 -0800
In-Reply-To: <4B7217CF.2080702@kernel.org> (Tejun Heo's message of "Wed\, 10 Feb 2010 11\:19\:59 +0900")
Message-ID: <m1vde57c11.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On 02/10/2010 11:08 AM, Américo Wang wrote:
>> This bug report is new for me. Recently we received lots of sysfs lockdep
>> warnings, I am working on a patch to fix all the bogus ones.
>> 
>> However, this one is _not_ similar to the other cases, as you decribed.
>> This patch could fix the problem, but not a good fix, IMO. We need more
>> work in sysfs layer to fix this kind of things. I will take care of this.
>
> Can't we just give each s_active lock a separate class?  Would that be
> too costly?

When I asked the question earlier I was told that that locking classes
require static storage.  Where would that static storage come from?

Eric
