Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYAJWT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYAJWT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYAJWTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:19:50 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:39138 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYAJWTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:19:49 -0500
Message-ID: <478699F0.9070306@tiscali.nl>
Date: Thu, 10 Jan 2008 23:19:28 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linville@tuxdriver.com, lkml <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, Elmer.Joandi@ut.ee, c.jennings@ieee.org
Subject: Re: [PATCH wireless/arlan] Replace logical- by bit-and
References: <4722453E.2090801@tiscali.nl>	<472248AC.7080201@tiscali.nl>	<47866EE9.80003@tiscali.nl> <20080110122859.569b3774.randy.dunlap@oracle.com>
In-Reply-To: <20080110122859.569b3774.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 10 Jan 2008 20:15:53 +0100 Roel Kluin wrote:
> 
>> diff --git a/drivers/net/wireless/arlan.h b/drivers/net/wireless/arlan.h
>> index 3ed1df7..7b7498f 100644
>> --- a/drivers/net/wireless/arlan.h
>> +++ b/drivers/net/wireless/arlan.h
>> @@ -485,7 +485,7 @@ struct arlan_private {
>>  #define clearClearInterrupt(dev){\
>>     writeControlRegister(dev,readControlRegister(dev) & ~ARLAN_CLEAR_INTERRUPT);}
>>  #define setPowerOff(dev){\
>> -   writeControlRegister(dev,readControlRegister(dev) | (ARLAN_POWER && ARLAN_ACCESS));\
>> +   writeControlRegister(dev, readControlRegister(dev) | (ARLAN_POWER & ARLAN_ACCESS));\
> 
> eh?  How does that help?

Right, sorry, please ignore my patch.

> Maybe it should be (ARLAN_POWER | ARLAN_ACCESS), but some
> arlan developer or someone with specs should help here...

I have CC'd the previous maintainers
