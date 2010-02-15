Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0BOMxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 07:53:13 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45379 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab0BOMxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 07:53:11 -0500
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "Tejun Heo \<tj\@kernel.org\> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] sysfs: Use sysfs_attr_init and sysfs_bin_attr_init on dynamic attributes
References: <4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>
	<20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org>
	<4B73671E.2050105@kernel.org> <m1bpfvxt67.fsf_-_@fess.ebiederm.org>
	<m14olnxt3s.fsf_-_@fess.ebiederm.org>
	<m1ljezwean.fsf_-_@fess.ebiederm.org>
	<m1hbpnwe7i.fsf_-_@fess.ebiederm.org>
	<m1d40bwe5i.fsf_-_@fess.ebiederm.org>
	<20100215103816.GK12076@hack.private>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 15 Feb 2010 04:53:06 -0800
In-Reply-To: <20100215103816.GK12076@hack.private> (=?utf-8?Q?=22Am=C3=A9r?=
 =?utf-8?Q?ico?= Wang"'s message of "Mon\, 15 Feb 2010 18\:38\:16 +0800")
Message-ID: <m1eikmbqz1.fsf@fess.ebiederm.org>
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

Américo Wang <xiyou.wangcong@gmail.com> writes:

> On Thu, Feb 11, 2010 at 03:23:05PM -0800, Eric W. Biederman wrote:
>>
>>These are the non-static sysfs attributes that exist on
>>my test machine.  Fix them to use sysfs_attr_init or
>>sysfs_bin_attr_init as appropriate.   It simply requires
>>making a sysfs attribute present to see this.  So this
>>is a little bit tedious but otherwise not too bad.
>>
>>Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
>
> Based on previous patches,
>
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> But it seems there are still some cases missed, e.g. the one
> reported by John. We can fix them when they appear.

Yes.  There is at least the module case that I sent a follow up
patch for.

Whacking these things when the appear isn't my favorite policy
but at least it is easy.

Eric
