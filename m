Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbZDSQMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbZDSQMD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 12:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758919AbZDSQLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 12:11:50 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:30481 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131AbZDSQLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 12:11:49 -0400
X-IronPort-AV: E=Sophos;i="4.40,213,1238976000"; 
   d="scan'208";a="156352060"
Message-ID: <49EB4D43.7080701@cisco.com>
Date: Sun, 19 Apr 2009 09:11:47 -0700
From: David VomLehn <dvomlehn@cisco.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Wait for console to become available, ver 3.1
References: <cs5Fw-2fr-1@gated-at.bofh.it> <E1LvF8O-0001hV-JE@be1.7eggert.dyndns.org>
In-Reply-To: <E1LvF8O-0001hV-JE@be1.7eggert.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> David VomLehn <dvomlehn@cisco.com> wrote:
> 
>> +     consoledelay=ms [KNL] Wait up to ms milliseconds for the preferred
>> +                     console to be registered, then continue. Useful for
>> +                     systems where a console may not be plugged in, such as
>> +                     for USB serial devices.
> 
>> +     consolewait     [KNL] Wait (indefinitely) for preferred console device
>> +                     to be registered. Useful, for example, for USB serial
>> +                     devices, but will never complete booting if no console
>> +                     is plugged in.
> 
> I'd use (consoledelay == -1) -> wait forever.

These are modelled after the way delays are done for the boot device, a 
consistency which should make them easier to remember. If others 
disagree, I am willing to implement your suggestion, though.

