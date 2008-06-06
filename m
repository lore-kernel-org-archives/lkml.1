Return-Path: <linux-kernel-owner+w=401wt.eu-S932748AbYFFVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbYFFVYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYFFVYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:24:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59253 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYFFVYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:24:17 -0400
Date: Fri, 6 Jun 2008 14:23:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Ilpo =?UTF-8?B?SsOkcnZpbmVu?=" <ilpo.jarvinen@helsinki.fi>
Cc: Patrick McManus <mcmanus@ducksong.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, peterz@infradead.org,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
       johnpol@2ka.mipt.ru
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
 v2.6.26-rc3+
Message-ID: <20080606142358.5af75c32@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0806062314420.9424@wrl-59.cs.helsinki.fi>
References: <20080603.150344.145518113.davem@davemloft.net>
	<Pine.LNX.4.64.0806040208350.7315@wrl-59.cs.helsinki.fi>
	<20080605142244.GA19216@elte.hu>
	<Pine.LNX.4.64.0806052059380.31672@wrl-59.cs.helsinki.fi>
	<Pine.LNX.4.64.0806052355420.2522@wrl-59.cs.helsinki.fi>
	<1212708571.19522.10.camel@tng>
	<Pine.LNX.4.64.0806061248410.16829@wrl-59.cs.helsinki.fi>
	<1212772293.23706.22.camel@tng>
	<20080606173339.GA30894@elte.hu>
	<Pine.LNX.4.64.0806062037240.9424@wrl-59.cs.helsinki.fi>
	<20080606183926.GB12651@elte.hu>
	<1212782937.23706.46.camel@tng>
	<Pine.LNX.4.64.0806062314420.9424@wrl-59.cs.helsinki.fi>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2008 00:12:55 +0300 (EEST)
"Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> wrote:
> Arjan, can you please check if your workload uses setsockopt 
> TCP_DEFER_ACCEPT for the LISTENing socket? ...If not, then your case
> is different from Ingo's.

at this point the observed hung I had seems to be the app doing
something bad (it's the app that hung) so for now please disregard my
previous comments on this topic.

> 
> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
