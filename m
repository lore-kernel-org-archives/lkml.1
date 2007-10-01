Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbXJAMEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbXJAMEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 08:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXJAMEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 08:04:40 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:51153 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXJAMEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 08:04:39 -0400
From: "Denys" <nuclearcat@nuclearcat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
Date: Mon, 1 Oct 2007 15:04:19 +0300
Message-Id: <20071001120231.M48591@nuclearcat.com>
In-Reply-To: <20071001115721.GB17357@one.firstfloor.org>
References: <20070930144443.M52139@visp.net.lb> <46FFE17C.9020202@cosmosbay.com> <200709301425.37564.nickpiggin@yahoo.com.au> <20070930220452.M25621@nuclearcat.com> <p73myv36tmz.fsf@bingen.suse.de> <20071001103026.M59805@nuclearcat.com> <20071001111441.GA17357@one.firstfloor.org> <20071001114715.M51349@nuclearcat.com> <20071001115721.GB17357@one.firstfloor.org>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 194.146.154.161 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That 2.6.21 works fine and 2.6.22 MUCH worse on multiple servers with similar
workload.
Plus all userspace becoming extremely unstable, and definitely ping 127.0.0.1
must not reach 300ms.


On Mon, 1 Oct 2007 13:57:21 +0200, Andi Kleen wrote
> On Mon, Oct 01, 2007 at 02:52:03PM +0300, Denys wrote:
> > Hi
> > 
> > No major differences. 
> > Some procedures higher a bit, some lower a bit, but everything looks fine on
> > both kernels.
> > 
> > Thats what i tried first - oprofile, and only one keypoint i was able to catch
> > - in top softirqd/0 or /1 shows usage 100% cpu, and in mpstat - soft% also
> > reaching 100%.
> 
> Then you likely just have higher load. What makes you think this
> is a kernel problem?
> 
> -Andi


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

