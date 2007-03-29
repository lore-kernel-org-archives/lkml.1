Return-Path: <linux-kernel-owner+w=401wt.eu-S1030341AbXC2QFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030341AbXC2QFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030344AbXC2QFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:05:53 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:6882
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030341AbXC2QFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:05:53 -0400
Message-Id: <460C0020.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 29 Mar 2007 17:06:24 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix dependency generation
References: <460BA292.76E4.0078.0@novell.com>
 <20070329083947.d9ba87e0.randy.dunlap@oracle.com>
In-Reply-To: <20070329083947.d9ba87e0.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Randy Dunlap <randy.dunlap@oracle.com> 29.03.07 17:39 >>>
>> --- linux-2.6.21-rc5/scripts/basic/fixdep.c	2007-02-04 19:44:54.000000000 +0100
>> +++ 2.6.21-rc5-fixdep-mod/scripts/basic/fixdep.c	2007-03-29 11:11:10.000000000 +0200
>> @@ -29,8 +29,7 @@
>>   * option which is mentioned in any of the listed prequisites.
>>   *
>>   * To be exact, split-include populates a tree in include/config/,
>> - * e.g. include/config/his/driver.h, which contains the #define/#undef
>> - * for the CONFIG_HIS_DRIVER option.
>
>I don't see why you deleted the line above.

Because it is no longer true. These files are empty as of 2.6.18.

Jan
