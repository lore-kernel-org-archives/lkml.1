Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab0CCKx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:53:56 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:53803 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0CCKxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:53:53 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 05:53:53 EST
Message-ID: <20100303114705.33716f9pnen8a8kc@webmail.df.eu>
Date: Wed, 03 Mar 2010 11:47:05 +0100
From: peter@piie.net
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] usb-serial / pl2302 corrupted receive
References: <cone.1267466820.296261.3385.1000@deskpiie>
 <20100302235353.GB2196@kroah.com>
In-Reply-To: <20100302235353.GB2196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.2)
X-Originating-IP: 80.82.223.8
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Quoting Greg KH <greg@kroah.com>:

> On Mon, Mar 01, 2010 at 07:07:00PM +0100, Peter Feuerer wrote:
>> I connected two pls2302 usb-serial converters to two different
>> usb-ports of my machine and connected them with a rs232-nullmodem
>> cable to each other.
>>
>> Terminal1:
>> cat /dev/ttyUSB1
>>
>> Terminal2:
>> while true; do echo 123456789012345678901234567890 > /dev/ttyUSB0 ; done
>
> cat and echo are known to not work well with usb to serial devices.  Can
> you duplicate this with a "real" tty program like minicom or something
> else?

I will try to set up a test use-case which uses kermit.

But there is a calltrace in kernel log when using cat & echo, so  
something in the driver went wrong.
Thus there is a bug which can be reproduced and it should be fixed,  
don't you agree?

best regards,
--peter



