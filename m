Return-Path: <linux-kernel-owner+w=401wt.eu-S934645AbYEBMWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934645AbYEBMWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934830AbYEBMWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:22:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:29344 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934893AbYEBMWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qQzTxq2VbXxLhqu1bTV7Y/1CsdmxR4pteP31P6G7Up1CXeO+I/KR3ciT/1O2hXWXARZPguyR8d06THfdQbqApRQemCZ8phO0IJRf0Abf+1UJUeNaZOXzzykdtGzNI4fBjgZhnY+OvXcCRRK6fX2p8EOganiCkkCPPsckAncPD+E=
Message-ID: <82e4877d0805020522o278ab3f5i21fc820084f85b97@mail.gmail.com>
Date: Fri, 2 May 2008 08:22:04 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: Horrendous Audio Stutter - current git
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200805021406.55038.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <200805021337.10809.elendil@planet.nl>
	 <1209728372.13978.147.camel@twins>
	 <200805021406.55038.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 8:06 AM, Frans Pop <elendil@planet.nl> wrote:
>  Note (mostly for Parag) that I had GROUP_SCHED disabled for these tests, but
>  for me that did make not any difference with my 2.6.25-rc tests for this
>  issue, nor with my tests using sched-devel earlier in the .26 merge window.
>

Strange - without the _enqueue patch from Peter, stutter is reduced to
an almost acceptable level for me if I just disable GROUP_SCHED.
With Peter's patch - I have tested multiple times and the stutter is
completely eliminated. So +1 for Peter's patch.

Mike recalls a regression that may be related - so it is possible you
were running w/o the affecting change.

Anyway - all is well in sched-land for now. Rejoice!

Parag
