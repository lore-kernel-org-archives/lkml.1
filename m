Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYKGVFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYKGVFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYKGVEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:04:48 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:38523 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYKGVEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:04:47 -0500
Message-ID: <4914ACED.8070207@oracle.com>
Date: Fri, 07 Nov 2008 13:02:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH 4/5] adt7473: Check inputs from sysfs writes
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>	<20081107185641.13022.70557.stgit@elm3a70.beaverton.ibm.com>	<20081107112040.0154e093.akpm@linux-foundation.org>	<1226090974.10478.15.camel@localhost> <20081107220019.74c60aa4@hyperion.delvare>
In-Reply-To: <20081107220019.74c60aa4@hyperion.delvare>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4914AD15.00D7:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Fri, 07 Nov 2008 12:49:34 -0800, Joe Perches wrote:
>> On Fri, 2008-11-07 at 11:20 -0800, Andrew Morton wrote:
>>>> +#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
>>> It might make sense to rename this to ROUND_CLOSEST, fix the
>>> double-evaluation and whap it into kernel.h?
>> ROUND_HALF_UP?
> 
> What would that supposedly mean?

Just go with DIV_ROUND_CLOSEST() or DIV_ROUND().
The _CLOSEST() is redundant to ROUND .. IMO.

-- 
~Randy
