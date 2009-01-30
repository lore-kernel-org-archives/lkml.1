Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZA3Gxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZA3Gxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 01:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZA3Gxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 01:53:42 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:18958 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZA3Gxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 01:53:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=MLJnjcy3U0AkWwCtq3hFXT7uT1qNYywkpwX1txKhj9sgANm4eO8Oaope407cZNZXAj
         KcGrPLd7VsqPIeabzV0dNXo2iqyByKRNBSBRmdvPjEjihiuHkkAYfp4zVvFVPq3b578W
         dWbfx+OSuhTb5egw5L7vELdbKuTrpnroRv+Yw=
MIME-Version: 1.0
In-Reply-To: <20090129063118.GA3586@pmhahn.de>
References: <20090129063118.GA3586@pmhahn.de>
Date: Thu, 29 Jan 2009 22:53:40 -0800
Message-ID: <86802c440901292253ie9e2a9dmb4580a3da1480c81@mail.gmail.com>
Subject: Re: WOL with forcedeth broken since f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 10:31 PM, Philipp Matthias Hahn
<pmhahn@titan.lahn.de> wrote:
> Hello!
>
> Somewhere between 2.6.26 and 2.6.27 WOL stopped working on my MS-7350
> motherboard with an "nVidia Corporation MCP51 Ethernet Controller (rev a3)".
>        "etherwake 00:19:db:f2:e1:35" did not work
>        "etherwake 35:e1:f2:db:19:00" did work
> Since I did a BIOS update during the same time window I (wrongly) put
> the fault on the BIOS. (See /sys/class/dmi/id/modalias for yourself:
> dmi:bvnAmericanMegatrendsInc.:bvrV1.7:bd07/29/2008:svnMSI:pnMS-7350:pvr1.0:rvnMSI:rnMS-7350:rvr1.0:cvnToBeFilledByO.E.M.:ct3:cvrToBeFilledByO.E.M.:
> )
>
> Today I finally found the time to test various old versions of
> "drivers/net/forcedeth.c" and also did a "git-bisect v2.6.26 v2.6.27"
> which lead to the following culprit:
>

can not find the reason why the WOL doesn't work...

please post
1. boot log for just after AC is pluged-in... ===> you should have
"nv_probe: set workaround bit for reversed mac addr"
2. and boot log after boot from WOL...==> you have have "nv_probe: set
workaround bit for reversed mac addr" too.

YH
