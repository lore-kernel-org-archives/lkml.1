Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbXIKOAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbXIKOAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbXIKOAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:00:30 -0400
Received: from zone4.gcu.info ([217.195.17.234]:54945 "EHLO
	zone4.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbXIKOA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:00:29 -0400
Date: Tue, 11 Sep 2007 15:59:31 +0200 (CEST)
To: mhoffman@lightlink.com, djwong@us.ibm.com
Subject: Re: [PATCH] v3 of IBM power meter driver
X-IlohaMail-Blah: khali@localhost
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.14 (On: mail.gcu-squad.org)
Message-ID: <QsqPsE00.1189519171.8421320.khali@localhost>
In-Reply-To: <20070911132335.GJ31992@jupiter.solarsys.private>
From: "Jean Delvare" <khali@linux-fr.org>
Bounce-To: "Jean Delvare" <khali@linux-fr.org>
CC: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       haveblue@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 9/11/2007, "Mark M. Hoffman" <mhoffman@lightlink.com> wrote:
>* Darrick J. Wong <djwong@us.ibm.com> [2007-08-28 16:25:05 -0700]:
>> --- a/drivers/hwmon/Kconfig
>> +++ b/drivers/hwmon/Kconfig
>> @@ -275,6 +275,18 @@ config SENSORS_CORETEMP
>>  	  sensor inside your CPU. Supported all are all known variants
>>  	  of Intel Core family.
>>
>> +config SENSORS_IBMPEX
>> +	tristate "IBM PowerExecutive temperature/power sensors"
>> +	depends on IPMI_SI
>
> Open question: can we use "select" here?  As written, it took some hunting
> to even get this driver to show up as an option in menuconfig.

My 2 cents: I assume that people who have IPMI-capable hardware are aware
that they do. Thus, if you change the above to "select IPMI_SI", you
probably want to add "depends on IPMI_HANDLER" (not sure why it's not
just named CONFIG_IPMI).

--
Jean Delvare
