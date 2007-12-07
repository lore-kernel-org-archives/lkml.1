Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbXLGXZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbXLGXZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXLGXZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:25:39 -0500
Received: from main.gmane.org ([80.91.229.2]:35883 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbXLGXZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:25:38 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: new card to me?
Date: Fri, 7 Dec 2007 23:25:23 +0000 (UTC)
Message-ID: <loom.20071207T230143-751@post.gmane.org>
References: <200712071319.39706.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 76.112.242.129 (Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9b1) Gecko/2007110904 Firefox/3.0b1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett <gene.heskett <at> gmail.com> writes:

> 
> Greetings;
> 
> Is this drive interface card supported by the current linux kernel?
> 
> Masscool XWT-RC018, as seen on tigerdirect's site:
> 
>
<http://www.tigerdirect.com/applications/SearchTools/item-details.asp?EdpNo=3501402&CatId=1455>
> 
> Thank you.
> 

The site says it is based on ALi M5283 and this[1] SATA support status page
(Revised Feb 27 2007) says it is supported and the driver is production quality.
sata_uli is the driver.

This [2] review over at Newegg says it works with Linux.

More over the changelogs for sata_uli.c do not indicate they removed support for
it and Google says people found and fixed bugs with that drive [3] - so it would
be a safe bet to say it should be supported with current kernels.

[1] http://linuxmafia.com/faq/Hardware/sata.html
[2] http://www.newegg.com/Product/Product.aspx?Item=N82E16815280001&Tpk=RC018
[3] http://bugzilla.kernel.org/show_bug.cgi?id=7590

[ I went through this recently when I had to buy a SATA card - I got one with a
Silicon Image chip for no particular reason ]

HTH
Parag

