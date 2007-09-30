Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbXI3W7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbXI3W7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXI3W72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:59:28 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:1075 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867AbXI3W71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:59:27 -0400
From: Frans Pop <elendil@planet.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.23-rc8-mm2] Fails to resume from s2mem (was:kernel BUG at mm/slab.c:591! ...)
Date: Mon, 1 Oct 2007 00:59:25 +0200
User-Agent: KMail/1.9.7
References: <200709282225.21530.elendil@planet.nl> <200709300015.36169.elendil@planet.nl> <20070930034556.43b9704d.akpm@linux-foundation.org>
In-Reply-To: <20070930034556.43b9704d.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710010059.25464.elendil@planet.nl>
X-OriginalArrivalTime: 30 Sep 2007 22:59:25.0886 (UTC) FILETIME=[8C5BF5E0:01C803B5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 September 2007, you wrote:
> On Sun, 30 Sep 2007 00:15:35 +0200 Frans Pop <elendil@planet.nl> wrote:
> > On Friday 28 September 2007, you wrote:
> > > My Toshiba Satellite A40 (i386, P4 Mobile) hangs during boot after:
> >
> > With 'hpet-force-enable-on-ich34' reverted the system boots OK again.
> >
> > We're not yet done though. It now fails to resume from suspend
>
> suspend-to-RAM?  Can you describe this failure a bit more?

The suspend is done from KDE by closing the lid, which runs a trivial 
script. The system seems to suspend normally (correct leds at the end).

When I open the lid again, the system seems to restart (fan starts, leds 
change), but the LCD only shows:
<cursor>      L
System cannot be reached over the net. After some time the fans speed up.

Exactly the same happens if I 'echo mem /sys/power/state' from console 
without X running.

BTW, that partial display is normal for me: I mostly see "Linu" until the 
switch to X.Org, but never a full sentence that makes sense.
*Is* that normal?
