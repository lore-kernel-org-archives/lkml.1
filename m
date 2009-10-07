Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZJGWNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZJGWNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbZJGWNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:13:37 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:48238 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbZJGWNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <20091007215247.GA730@trillian.comsick.at>
References: <20091007175403.GA335@trillian.comsick.at> <9b2b86520910071246r393f2afvacaa4d8f544508a8@mail.gmail.com> 
	<ac3eb2510910071306r4ad6dc9btb7503bc3ab0ec815@mail.gmail.com> 
	<ac3eb2510910071312qe6ad45ep6c579a8393cc6b8e@mail.gmail.com> 
	<20091007203121.GA432@trillian.comsick.at> <ac3eb2510910071353v3bbe5bc7lc41e184fbc1ff7ed@mail.gmail.com> 
	<1254950602.2307.1.camel@yio.site> <20091007215247.GA730@trillian.comsick.at>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 8 Oct 2009 00:11:22 +0200
Message-ID: <ac3eb2510910071511o48e9fc12sb8e65a8214449c8d@mail.gmail.com>
Subject: Re: [BUG] No ttyS0 - Strange udev 8250_pnp interaction
To: Michael Guntsche <mike@it-loops.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-hotplug <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 23:52, Michael Guntsche <mike@it-loops.com> wrote:
> On 2009.10.07 23:23:22 , Kay Sievers wrote:
>> Michael, you mentioned trying the udev git version. Any chance to check
>> if that fixes it?
>
> I applied it to current git and gave it a quick spin with.
>
> rmmod 8250_pnp;sleep 1;ls -la /dev/ttyS*;modprobe 8250_pnp;sleep 1;ls
> -la /dev/ttyS*
>
> I was not able to reproduce the problem even after 30 runs.
> I will let it run some more just to be sure but so far it looks good.

Thanks for the tests. It's in git now.

Kay
