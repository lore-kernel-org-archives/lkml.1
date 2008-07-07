Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbYGGRRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbYGGRRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYGGRRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:17:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42255 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752927AbYGGRRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:17:41 -0400
Message-ID: <48724FB4.3090305@sgi.com>
Date: Mon, 07 Jul 2008 10:17:40 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com> <m1wsk3r3g6.fsf@frodo.ebiederm.org>
In-Reply-To: <m1wsk3r3g6.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>> will only boot and run with gcc-4.2.0, and does the "failure at grub" screen
>> with
>> gcc-4.2.4 ...!
> 
> Do these tests have an early serial console enabled?  I want to confirm
> that the failure is very early in boot before or just as we reach C code.
> 
> If you don't have an early console we could be failing late in the process just
> not have visibility.
> 
>> Any other suggestions?
> 
> If you have a serial console to add a little bit of instrumentation super duper early.
> Although looking at the generated objects might be just as interesting.
> 
> Eric

Hi,

Sorry for the delay, been off the past 4 days.

I'll see how closely I can narrow down where the fault is.  I have been inserting
very early printk's to track how far into the startup it gets before bailing.

Thanks,
Mike
