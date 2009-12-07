Return-Path: <linux-kernel-owner+w=401wt.eu-S934705AbZLGMYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbZLGMYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934287AbZLGMYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:24:09 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:54723 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933842AbZLGMYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:24:08 -0500
Message-ID: <4B1CF3ED.4040305@simtec.co.uk>
Date: Mon, 07 Dec 2009 12:24:13 +0000
From: Ben Dooks <ben@simtec.co.uk>
Organization: Simtec Electronics, UK
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Wolfram Sang <w.sang@pengutronix.de>, doong.ping@micrel.com,
       tristram.ha@micrel.com, linux@simtec.co.uk
Subject: Re: [patch 1/9] eeprom_93cx6: Add data direction control.
References: <20091207121727.016092171@fluff.org.uk>	<20091207121827.433183360@fluff.org.uk> <20091207132141.1db65cd3@hyperion.delvare>
In-Reply-To: <20091207132141.1db65cd3@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Mon, 07 Dec 2009 12:17:28 +0000, Ben Dooks wrote:
>> Some devices need to know if the data is to be output or read, so add a
>> data direction into the eeprom structure to tell the driver whether the
>> data line should be driven.
>>
>> The user in this case is the Micrel KS8851 which has a direction
>> control for the EEPROM data line and thus needs to know whether
>> to drive it (writing) or to tristate it for receiving.
>>
>> Signed-off-by: Ben Dooks <ben@simtec.co.uk>
>> Cc: Wolfram Sang <w.sang@pengutronix.de>
>> Cc: Jean Delvare <khali@linux-fr.org>
>> Cc: Linux Kernel <linux-kernel@vger.kernel.org>
> 
> FYI, I will not be reviewing this patch nor any other patch to the
> eeprom_93cx6 driver. I have no clue what these devices are, no access
> to any and no interest in them either.

Ok, scripts/get_maintainer.pl came up with yourself, Wolfram and linux-kernel
as the people to send this to.

-- 
Ben Dooks, Design & Software Engineer, Simtec Electronics

http://www.simtec.co.uk/
