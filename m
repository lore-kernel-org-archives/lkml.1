Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbXLKABT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbXLKABT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 19:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXLKABL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 19:01:11 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:34983 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbXLKABK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 19:01:10 -0500
Date: Tue, 11 Dec 2007 00:53:53 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071211005353.55bcbc1e@inria.fr>
In-Reply-To: <20071211003433.5cf0230d@morte>
References: <200712080340.49546.rjw@sisk.pl>
	<20071210204212.GA5502@elte.hu>
	<20071210125923.37bd2f10.akpm@linux-foundation.org>
	<20071210224508.GB27178@elte.hu>
	<20071210230425.GA641@elte.hu>
	<20071211003433.5cf0230d@morte>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefano Brivio <stefano.brivio@polimi.it> wrote:

> Sorry for disappearing. Anyway, yes, those patches fixed it. Precision in
> delays isn't that good when using my crappy unstable TSC (mdelay(2000)
> causes delays between 2 and 2.9 seconds) but it's not depending on frequency
> changes anymore. So I'd say it's fixed, but please tell me if you want me
> to do any other test so as to be sure it is.

Ingo,

it seems you dropped http://lkml.org/lkml/2007/12/7/100 (cpu_clock()
based udelay), so how udelay can be affected by your proposed changes?

Thanks.

-- 
Guillaume
