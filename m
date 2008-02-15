Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbYBOTnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbYBOTnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYBOTnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:43:08 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:44668 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYBOTnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:43:07 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG/ spinlock lockup, 2.6.24
Date: Fri, 15 Feb 2008 21:42:47 +0200
Message-Id: <20080215193854.M55147@visp.net.lb>
In-Reply-To: <e2e108260802150724k4e5e6089mcb603b524157a9bc@mail.gmail.com>
References: <20080215150044.M24489@visp.net.lb> <e2e108260802150724k4e5e6089mcb603b524157a9bc@mail.gmail.com>
X-Mailer: OpenWebMail 2.52 
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This server was working fine under load under FreeBSD, and worked fine before 
with other tasks under Linux. I dont think it is RAM.
Additionally it is server hardware (Dell PowerEdge) with ECC, MCE and other 
layers, who will report about any hardware issue most probably, and i think 
even better than memtest. 
Additionally it is very difficult to run test on it, cause it is in another 
country, and i have limited access to it (i dont have network KVM).

I have similar crashes on completely different hardware with same job (QOS), 
so i think it is actually some nasty bug in networking.


On Fri, 15 Feb 2008 16:24:56 +0100, Bart Van Assche wrote
> 2008/2/15 Denys Fedoryshchenko <denys@visp.net.lb>:
> >  I have random crashes, at least once per week. It is very difficult to 
catch
> >  error message, and only recently i setup netconsole. Now i got crash, but
> >  there is no traceback and only single line came over netconsole, 
mentioned
> >  before.
> 
> Did you already run memtest ? You can run memtest by booting from the
> Knoppix CD-ROM or DVD. Most Linux distributions also have included
> memtest on their bootable distribution CD's/DVD's.
> 
> Bart Van Assche.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

