Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381Ab0ANDJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0ANDJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 22:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145Ab0ANDJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 22:09:23 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49863 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0ANDJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 22:09:22 -0500
To: Miles Lane <miles.lane@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: 2.6.33-rc3 -- INFO: possible recursive locking --  (s_active){++++.+}, at: [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
References: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com>
	<2375c9f91001100058w4bac1cf9s183fc37eafbfde75@mail.gmail.com>
	<m13a2dho1o.fsf@fess.ebiederm.org> <201001101935.31882.rjw@sisk.pl>
	<m1wrzpbcmi.fsf@fess.ebiederm.org>
	<a44ae5cd1001131847l582ad373j9a5c944327a06a0a@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 13 Jan 2010 19:09:06 -0800
In-Reply-To: <a44ae5cd1001131847l582ad373j9a5c944327a06a0a@mail.gmail.com> (Miles Lane's message of "Wed\, 13 Jan 2010 21\:47\:11 -0500")
Message-ID: <m1k4vl9yct.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane <miles.lane@gmail.com> writes:

> Hmm.  I tried your patch applied to a clean 2.6.33-rc4 tree, and used
> the same .config file.  This time the INFO looks a lot like my
> original bug report.  Weird.  Maybe I am doing something wrong!

I agree weird.  Either you don't have my patch working correctly or I
talk a good good game but I don't have a clue about lockdep
subclasses.

Grrr.

Now to see if I can find some time to dig into this.  Thank you very
much for testing.

Eric

