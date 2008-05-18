Return-Path: <linux-kernel-owner+w=401wt.eu-S1763844AbYERMan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763844AbYERMan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762905AbYERMYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:24:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:58028 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760329AbYERMX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d808Xu6Si8QqixUvcKgNiD4SDrfxbjCz2q51MxK3BWmg6gLFQRZxjlSwRQNQHDQHhnSbzZXnRQxopEIduf7UqJp9+OoJgMK5xRCQko6aTxb78I2+epCpvUJ8QoZpRS6Zwvu8eXdEyGae0nLBJ8bUSF8S/k8Pc0/EPGms7It9M1k=
Message-ID: <19f34abd0805180523o12732812k87b8ddd832843af4@mail.gmail.com>
Date: Sun, 18 May 2008 14:23:59 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10710] [BISECTED] Lots of "rescheduling IPIs" in powertop
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>, "Andi Kleen" <andi@firstfloor.org>,
       "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <7wuznNhcUqC.A.xiH.EsBMIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.xiH.EsBMIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 1:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10710
> Subject         : [BISECTED] Lots of "rescheduling IPIs" in powertop
> Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> Date            : 2008-05-13 20:42 (6 days old)
> References      : http://marc.info/?l=linux-kernel&amp;m=121071176205864&amp;w=4
> Handled-By      : Andi Kleen <andi@firstfloor.org>
>                  Arjan van de Ven <arjan@infradead.org>
>                  Ingo Molnar <mingo@elte.hu>
> Patch           : http://marc.info/?l=linux-kernel&amp;m=121074826823352&amp;w=4
>

Ingo Molnar provided the patch that solved the problem (the referenced
link) but he wanted to wait for Andreas Herrmann to provide an
additional patch that would solve some implication on AMD CPUs. So
this is in theory fixed, but the fix has not yet been applied anywhere
as far as I know.

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
