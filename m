Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZJ0KTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZJ0KTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZJ0KTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:19:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43700 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753012AbZJ0KTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:19:06 -0400
Date: Tue, 27 Oct 2009 10:19:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>, <mingo@elte.hu>,
       <yinghai@kernel.org>, <tglx@linutronix.de>, <tiwai@suse.de>,
       <linux-kernel@vger.kernel.org>, <jbarnes@virtuousgeek.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent  allocations
Message-ID: <20091027101943.7fd39c1c@lxorguk.ukuu.org.uk>
In-Reply-To: <4AE6CA2A020000780001BF51@vpn.id2.novell.com>
References: <4AE5D238020000780001BD46@vpn.id2.novell.com>
	<20091026201917.GE24682@elte.hu>
	<4AE6C4D3020000780001BF13@vpn.id2.novell.com>
	<20091027181053L.fujita.tomonori@lab.ntt.co.jp>
	<4AE6CA2A020000780001BF51@vpn.id2.novell.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> to eliminate the fallback right away. Hence, with it having got broken
> in .26 I think it is reasonable to fix it for the time being.

And .26 was released by distributions when ?

Perhaps that says something about how many WARN_ON()s are likely to show
up ;)

Alan
