Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbZDUTDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbZDUTDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZDUTDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:03:40 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:45402 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751644AbZDUTDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:03:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kc+eJlqtEDLXX8am/rB7dHE8XcrJMa+47qf+aU5LGhsvfqbCCkGK9fZEzWqj0yvtwvdO6J+97uf6xpymtmFKHky3I47Hb3dayfcjnCLupC/jinZr+g9/bLNEnVSNf/NJXdnwPGSMEh/+Ap+eTQWt5q1ZjyyOYjHyn54lOlro/p8=  ;
X-YMail-OSG: GarREXQVM1mmWRLAUfHg.ZaMQF6mg2DViX.bkgFsJFjrl9ZACZYVO.sYG.PH1VdRsjZkfJqgz3jSeVILWsV7Y5ahanOhuSiwZJpuHbmgtAMJO789XJYnS_AiqMHZROBnwWJvdcZOaWVMrqzlssr10mFjrm7mt0CQzgDwJe2aUEABl93.jdsxxc5G.KbazVvCT69OUXW.y_dq3Q4Tql.NhpORH5dPZuZ0bGw5jf7YeiWSpVvCEfBvNxW6E94xud8a9BjWRPrA2MmdtXAReWK7rQRiyWUp7DiNnr7RF0SKjPpv.n25LI4UzO5Rz1K27Kue.GrsYsJp0UByKyrFqeK9kKLzeq7pqZHEyZvaNahy0Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: subrata@linux.vnet.ibm.com
Subject: Re: [BUILD FAILURE 11/12] Next April 21 : PPC64 randconfig [drivers/usb/host/ohci-hcd.o]
Date: Tue, 21 Apr 2009 12:03:36 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, "Linuxppc-dev" <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next" <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
References: <1240340081.9110.144.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1240340081.9110.144.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904211203.36969.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 April 2009, Subrata Modak wrote:
> Observing this for the first time:
> 
> CC      drivers/usb/host/ohci-hcd.o
> In file included from drivers/usb/host/ohci-hcd.c:1060:
> drivers/usb/host/ohci-ppc-of.c:242:2: error: #error "No endianess

Hmm, scripts/get_maintainer.pl doesn't report
the PPC folk who maintain that file and its
kbuild infrastructure.

Can we have some PPC folk look at (and fix) this?


> selected for ppc-of-ohci"
> make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1
> make[2]: *** [drivers/usb/host] Error 2
> make[1]: *** [drivers/usb] Error 2
> make: *** [drivers] Error 2
> ---
> 
> Regards--
> Subrata
> 
> 


