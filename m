Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbYHPG5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbYHPG5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 02:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYHPG5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 02:57:16 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:54862 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYHPG5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 02:57:16 -0400
Message-ID: <39683.166.70.238.45.1218868398.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <87pro9xyhu.fsf@basil.nowhere.org>
References: <200808160341.m7G3flhk022569@wolfmountaingroup.com>
    <87pro9xyhu.fsf@basil.nowhere.org>
Date: Sat, 16 Aug 2008 00:33:18 -0600 (MDT)
Subject: Re: [PATCH 2.6.27-rc3 19/28] mdb: adding notify_die handler for 
     keyboard debugger entry
From: jmerkey@wolfmountaingroup.com
To: "Andi Kleen" <andi@firstfloor.org>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> jmerkey@wolfmountaingroup.com writes:
>
>> +#if defined(CONFIG_MDB) || defined(CONFIG_MDB_MODULE)
>> +	if (down && !rep && keycode == KEY_PAUSE)
>> +        {
>> +	   if (notify_die(DIE_KERNELDEBUG, NULL, get_irq_regs(),
>> +                          0, -1, SIGINT) == NOTIFY_STOP)
>> +	      return;
>> +	}
>> +#endif
>> +
>>  #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
>>  	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt)))
>> {
>>  		if (!sysrq_down) {
>
> A nicer alternative to adding an hook here would be to use
> register_sysrq_key() to register a sysrq key that triggers
> the debugger.  That function is also already exported.
>
> -Andi
>

Got it.  Added to the list.  I will Instrument it.

Jeff

