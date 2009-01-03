Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbZACLKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbZACLKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 06:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZACLKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 06:10:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:60661 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZACLKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 06:10:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sE0+sqsv0HT9FspRA6IwCyBxwSP3k308MzkbmtpNdMx+tEiF9SdtiBA7EX9Wm0gc82
         NJWVv+tDs4q3g+8Vx0ginkSndWOzMBNrnKNVIIwNoYu4vyJ3Fl/edT3x8n9m6q/sUzI0
         tZoGZTFHAr1nf1KjlzHUf1NwK0WRsJukXewNk=
Message-ID: <3f9a31f40901030310l211e3ca8hd3c7d2b0e7b18adc@mail.gmail.com>
Date: Sat, 3 Jan 2009 16:40:29 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: BUG - 2.4.37 fealnx.c NETDEV WATCHDOG: eth0: transmit timed out
Cc: "Willy Tarreau" <w@1wt.eu>, wtarreau@hera.kernel.org,
       kernel-testers@vger.kernel.org, netdev@vger.kernel.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090102185718.GB20741@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40901020640m4a9a63caq9c96ba84ccd64d88@mail.gmail.com>
	 <20090102144813.GA13757@1wt.eu>
	 <3f9a31f40901020748m242c46djf153fbab90eeca60@mail.gmail.com>
	 <20090102185718.GB20741@electric-eye.fr.zoreil.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 3, 2009 at 12:27 AM, Francois Romieu <romieu@fr.zoreil.com> wrote:
> Jaswinder Singh Rajput <jaswinderlinux@gmail.com> :
> [..]
>> Output of mii-diag -v :
>> eth0: 10 Mbit, half duplex, no link
>>   product info: vendor 00:00:00, model 0 rev 0
>>   basic mode:   10 Mbit, half duplex
>>   basic status: no link
>>   capabilities:
>>   advertising:
>>
>> This is the output from very old machine Pentium MMX with Redhat 7.1
>
> Can you check with 'mii-tool -vv eth0' that the mii registers are not
> all zeroes ?
>

Yes all are zeros :-)

eth0: 10 Mbit, half duplex, no link
  registers for MII PHY 32:
    0000 0000 0000 0000 0000 0000 0000 0000
    0000 0000 0000 0000 0000 0000 0000 0000
    0000 0000 0000 0000 0000 0000 0000 0000
    0000 0000 0000 0000 0000 0000 0000 0000
  product info: vendor 00:00:00, model 0 rev 0
  basic mode:   10 Mbit, half duplex
  basic status: no link
  capabilities:
  advertising:

Now what is next step.

Thank you,
JSR
