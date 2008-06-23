Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbYFWPcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbYFWPcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYFWPcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:32:42 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:30588 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbYFWPcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=H642Gi9H6nEPZ2ua99ncIxmMlyT96jb31NCURZz8v18xroaMUutsAd4Lo+nbX9nXFy
         fvdXByqyttMg7WPjwI8jsk4UIKHbli1Xj1CfdBpc095R0lbJp0VlE7lniepdhZm+4Umc
         fHAeGI4acIDpx+Lm63KkZARpNDoRMBlxdI3E4=
Message-ID: <b6a2187b0806230832j10e8be28vc0b05fea233437fa@mail.gmail.com>
Date: Mon, 23 Jun 2008 23:32:28 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 2/5] Reinstate ZERO_PAGE optimization in get_user_pages() and fix XIP
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, "Willy Tarreau" <w@1wt.eu>,
       "Rodrigo Rubira Branco" <rbranco@la.checkpoint.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Oleg Nesterov" <oleg@tv-sign.ru>, "Nick Piggin" <npiggin@suse.de>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Hugh Dickins" <hugh@veritas.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Roland McGrath" <roland@redhat.com>
In-Reply-To: <20080622202950.GB20800@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622185327.348377223@mini.kroah.org>
	 <20080622190140.GD20141@suse.de>
	 <alpine.LFD.1.10.0806221220530.2926@woody.linux-foundation.org>
	 <20080622202950.GB20800@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 4:29 AM, Greg KH <gregkh@suse.de> wrote:
> On Sun, Jun 22, 2008 at 12:22:47PM -0700, Linus Torvalds wrote:
>> Let's wait for the vmware breakage report to sort out first.
>>       http://lkml.org/lkml/2008/6/22/10
>> before moving it to -stable.
>
> Sure, thanks for pointing that out to me, I'll track it as well.

I can confirm that the 2nd patch from Linus fixed the problem.

               http://lkml.org/lkml/2008/6/22/107

Sorry it took so long. Traveling.

Thanks,
Jeff.
