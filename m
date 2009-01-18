Return-Path: <linux-kernel-owner+w=401wt.eu-S933173AbZARKSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173AbZARKSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 05:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbZARKSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 05:18:35 -0500
Received: from web110601.mail.gq1.yahoo.com ([67.195.13.192]:27258 "HELO
	web110601.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760359AbZARKSe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 05:18:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=wZzpQ8MFStHAwSYI9R80asWCqUUfBx7wgpRlRBbiCoOCPaWRpvSSLAY6C068svc2b62OdDShLIe42cMSIGDVhU1K98a1YpkZ6nbgsPul8Q5J07ydWC2M0cxFJucDc3RfaFl6n8P9A10yfCF5BxilsWOm9WxndQRqfjshRPXq94U=;
X-YMail-OSG: WDKdTt0VM1lsaC9.ojkwuSZfCcZlbcnRWMhQPsd.jKsxAwHi4bae2crcg1CKO0T13gxUcohAkvlyz9HrEMcIRbaIFrAM1l5f_GX4PJnKb0YKiVSldjDGVRxPdPLTw5rdio9JUYmnFqGTT22jXdDygeXkPoMCoqMU6rwVFQcCxyzZPZaa7CF.xejB5bMy7vhBNSSVZOwFFrTbhX9s_0OFEupAFFX7Hw--
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
References: <gkt97e$ti0$1@ger.gmane.org> <20090117194045.649f55a0@osprey.hogchain.net>
Date: Sun, 18 Jan 2009 02:18:33 -0800 (PST)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [atl2] warn_slowpath in dev_watchdog
To: Jay Cliburn <jcliburn@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>,
       jie.yang@atheros.com, atl1-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <767752.95325.qm@web110601.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


> From: Jay Cliburn <jcliburn@gmail.com>
> 
> On Sat, 17 Jan 2009 18:49:18 +0000 (UTC)
> Sitsofe Wheeler wrote:
> 
> > On an ever so slightly modified 2.6.28. I think this only happens
> > when the upstream router/switch goes out to lunch and packets are
> > being sent. It is reproducible but only appears on a home network...
> > 
> > [  204.704065] ------------[ cut here ]------------
> > [  204.704074] WARNING: at net/sched/sch_generic.c:226 dev_watchdog
> > +0x22b/0x240()
> > [  204.704080] NETDEV WATCHDOG: eth0 (atl2): transmit timed out
> 
> Please provide your complete dmesg output.

Unfortunately I only saved that snippet of the log (I can provide you a full dmesg but it won't be
from a run where this problem occured).
 
> Can you briefly describe the device immediately upstream of the system producing
> the warning?

I believe it is a USRobotics ADSL modem (nmap reckons its a SureConnect 9105 but I have no means of checking as I don't have physical access to the box where it is contained). Every now and again this thing seems to buckle under network load and goes out to lunch. When this happens ethtool reports that the line has dropped and sometimes this warning appears...



      
