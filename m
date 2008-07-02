Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbYGBCkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbYGBCkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbYGBCkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:40:04 -0400
Received: from outbound-mail-106.bluehost.com ([69.89.22.6]:53144 "HELO
	outbound-mail-106.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757927AbYGBCkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:40:01 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
Date: Tue, 1 Jul 2008 19:39:53 -0700
User-Agent: KMail/1.9.9
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <20080526234940.GA1376@xs4all.net> <200806101014.25089.jbarnes@virtuousgeek.org> <20080626113855.GE29619@elte.hu>
In-Reply-To: <20080626113855.GE29619@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011939.53427.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 26, 2008 4:38 am Ingo Molnar wrote:
> that branch is always based in -git so if stuff goes upstream patches
> disappear from it. git-log linus/master..tip/pci-for-jesse should tell
> the currently pending items. Right now it's just two lowprio items:
>
>  Yinghai Lu (2):
>       pci: debug extra pci resources range
>       pci: debug extra pci bus resources

It looks like these add some new, unconditional debug output?  I guess I 
shouldn't worry about printks so much at this point, given how much 
obsolete/uninteresting info gets dumped these days, but it would be nice if 
this were only dumped if some debug option were set.  Given the variety of 
PCI stuff we might like to dump at various times, maybe it's time we added a 
few new pci=debug=foo options?  Yinghai?

Thanks,
Jesse
