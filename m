Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZHNF1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZHNF1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 01:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZHNF1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 01:27:09 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:36745 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbZHNF1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 01:27:08 -0400
From: Dhananjay Phadke <dhananjay.phadke@qlogic.com>
To: David Miller <davem@davemloft.net>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Amit Salecha <amit.salecha@qlogic.com>
Date: Thu, 13 Aug 2009 22:27:04 -0700
Subject: RE: linux-next: manual merge of the net tree with the net-current
 tree
Thread-Topic: linux-next: manual merge of the net tree with the net-current
 tree
Thread-Index: AcocigAhpNO+9VZ3TpOposkCyXLsSgADpTsw
Message-ID: <7608421F3572AB4292BB2532AE89D565859E617F37@AVEXMB1.qlogic.org>
References: <20090814124040.534dd43c.sfr@canb.auug.org.au>
 <20090813.195042.203385912.davem@davemloft.net>
In-Reply-To: <20090813.195042.203385912.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 14 Aug 2009 05:26:54.0379 (UTC) FILETIME=[D5ADB7B0:01CA1C9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well yeah, I had already confessed in the introductory mail.

http://article.gmane.org/gmane.linux.network/135134

I have verified my own cherry-picked version of net-next driver,
will do that again once Dave fixes the tree.

Thanks,
Dhananjay 

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net] 
> Sent: Thursday, August 13, 2009 19:51
> To: sfr@canb.auug.org.au
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; 
> Dhananjay Phadke; Amit Salecha
> Subject: Re: linux-next: manual merge of the net tree with 
> the net-current tree
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 14 Aug 2009 12:40:40 +1000
> 
> > Hi David,
> > 
> > Today's linux-next merge of the net tree got a conflict in
> > drivers/net/netxen/netxen_nic_main.c between commits
> > e424fa9d6a0add1a9b812b07e3607daaa5b9e53d ("netxen: remove netxen
> > workqueue") and 232e7d68d50c9ac3a55d716e5ae215ecd1e043b9 
> ("netxen: free
> > napi resources during detach") from the net-current tree and commits
> > 6598b169b856793f8f9b80a3f3c5a48f5eaf40e3 ("netxen: enable ip addr
> > hashing"), f17443f4b01659a5c44d5fc6f5c502c39c293959 
> ("netxen: refactor
> > net_device setup code") and 7042cd8f148345bfca6c336f009c96a416674f5e
> > ("netxen: support for ethtool set ringparam") from the net tree.
> > 
> > I fixed it up (I hope) (see below) and can carry the fix as 
> necessary.
> 
> Thanks for the note Stephen.
> 
> I'll do a merge of net-2.6 into net-next-2.6 to resolve this
> and get it out of your hair.
> 
> No virus found in this incoming message.
> Checked by AVG - www.avg.com 
> Version: 8.5.392 / Virus Database: 270.13.54/2300 - Release 
> Date: 08/13/09 18:16:00
> 