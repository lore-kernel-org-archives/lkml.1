Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZA0Ja2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZA0Ja2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 04:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZA0JaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 04:30:11 -0500
Received: from web110606.mail.gq1.yahoo.com ([67.195.13.197]:30118 "HELO
	web110606.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751697AbZA0JaK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 04:30:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=EfD/ApNSxEmdy0RfFOIByJiME3TdW1I9Id4Wjf0ZuNOkFgIQB2jOKO/HHboL5iRPUhQDgAsMaKJvq1zY8mMmvybNfvxWem9/0ixwbgPtpHcIEJEm4ZzNf6oQauz8Off9WP8nN+oKa06t0WjYBf9GmxA7rqsQ96tW3ZikBjK86gM=;
X-YMail-OSG: 16mOBmcVM1kqpo6YCSs53VxJGs4c4a6yUvQeQ1PNldvanfQ8SUZ_C7pSl75rZPPVm_81ncD5ivhGvn7u01CInrlUVhWzY0QmKGL9.Ys_cMzrawHSvTyGeyKWuH.8zAZZfe2bJfJvtV2c6KzR0_XMnN2rjR1lYD58DI0teBFg6E2RgGi1oKYWPIaNA9EZYbbMk3edrAHbVid_l2IpA2Rc3605qfK.Qg--
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
References: <gkt97e$ti0$1@ger.gmane.org> <20090117194045.649f55a0@osprey.hogchain.net> <767752.95325.qm@web110601.mail.gq1.yahoo.com> <20090118095231.2c73c448@osprey.hogchain.net> <879024.62535.qm@web110609.mail.gq1.yahoo.com> <20090118115858.1b636b2d@osprey.hogchain.net> <884897.63360.qm@web110608.mail.gq1.yahoo.com> <20090125210017.04e38348@osprey.hogchain.net>
Date: Tue, 27 Jan 2009 01:30:08 -0800 (PST)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [atl2] warn_slowpath in dev_watchdog
To: Jay Cliburn <jcliburn@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>,
       jie.yang@atheros.com, atl1-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <115072.73028.qm@web110606.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 > From: Jay Cliburn <jcliburn@gmail.com>

> 
> On Sun, 25 Jan 2009 08:17:25 -0800 (PST)
> Sitsofe Wheeler wrote:
> 
> > OK the circumstances took a lllllong time to occur again but the result is 
> that
> > the patch does not prevent the warning. 
> 
> Can you trigger the warning by performing these steps while the interface is up?
> 
> unplug cable
> ifdown eth0
> ifup eth0
> replug cable      
> wait about 5 seconds...
> 
> If it doesn't happen the first time, try 3 or 4 more times.
> 
> Let me know what happens.

The slowpath warning never comes up with this method. I tried with the commands ifdown eth0; ifup eth0 (after removing network manager's control of the device) and ifconfig eth0 down; ifconfig eth0 up (with and without network manager) but none of the aforementioned resulted in an error.



      
