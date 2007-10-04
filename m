Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbXJDFPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbXJDFPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 01:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbXJDFO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 01:14:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:13772 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbXJDFO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:14:59 -0400
Message-ID: <47047651.6040808@oracle.com>
Date: Wed, 03 Oct 2007 22:12:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnpol@2ka.mipt.ru
Subject: Re: + add-documentation-w1w1-masters-00-index.patch added to -mm
 tree
References: <200710032117.l93LHXI0009109@imap1.linux-foundation.org> <20071003143849.46c7f157.randy.dunlap@oracle.com> <200710032046.03751.rob@landley.net>
In-Reply-To: <200710032046.03751.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
>>> +	- The Maixm/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.
>>               Maxim (2 times)
> 
> That typo was cut and paste from the the "Description" section of both files.  
> (Lines 18 and 13, respectively.)  :(
> 
> Attached is an updated version that spells it "maxim" and also fixes the typos 
> in the source files, if that helps...
> 
>> Was this patch posted to a mailing list?  if so, which one?
>> I didn't see it.
> 
> LKML on saturday.
> http://lkml.org/lkml/2007/9/29/168
> 
> My pending patches are all at http://landley.net/kdocs/make/patches although 
> I'm waiting for the current batch to work through before posting more.


Thanks.  Looks good.

> From: Rob Landley <rob@landley.net>
> 
> Two 00-INDEX files under Documentation/w1 plus typo fixes.
> 
> Signed-off-by: Rob Landley <rob@landley.net>
> ---
> 
>  Documentation/w1/masters/ds2482 |    2 +-
>  Documentation/w1/masters/ds2490 |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff -r de183081194a Documentation/w1/masters/ds2482
> --- a/Documentation/w1/masters/ds2482	Tue Oct 02 18:00:56 2007 +0000
> +++ b/Documentation/w1/masters/ds2482	Wed Oct 03 20:28:05 2007 -0500
> @@ -15,7 +15,7 @@ Description
>  Description
>  -----------
>  
> -The Maixm/Dallas Semiconductor DS2482 is a I2C device that provides
> +The Maxim/Dallas Semiconductor DS2482 is a I2C device that provides
>  one (DS2482-100) or eight (DS2482-800) 1-wire busses.
>  
>  
> diff -r de183081194a Documentation/w1/masters/ds2490
> --- a/Documentation/w1/masters/ds2490	Tue Oct 02 18:00:56 2007 +0000
> +++ b/Documentation/w1/masters/ds2490	Wed Oct 03 20:28:05 2007 -0500
> @@ -10,7 +10,7 @@ Description
>  Description
>  -----------
>  
> -The Maixm/Dallas Semiconductor DS2490 is a chip
> +The Maxim/Dallas Semiconductor DS2490 is a chip
>  which allows to build USB <-> W1 bridges.
>  
>  DS9490(R) is a USB <-> W1 bus master device
> --- /dev/null	2007-04-23 10:59:00.000000000 -0500
> +++ hg/Documentation/w1/00-INDEX	2007-10-03 20:26:38.000000000 -0500
> @@ -0,0 +1,8 @@
> +00-INDEX
> +	- This file
> +masters/
> +	- Individual chips providing 1-wire busses.
> +w1.generic
> +	- The 1-wire (w1) bus
> +w1.netlink
> +	- Userspace communication protocol over connector [1].
> --- /dev/null	2007-04-23 10:59:00.000000000 -0500
> +++ hg/Documentation/w1/masters/00-INDEX	2007-10-03 20:26:55.000000000 -0500
> @@ -0,0 +1,6 @@
> +00-INDEX
> +	- This file
> +ds2482
> +	- The Maxim/Dallas Semiconductor DS2482 provides 1-wire busses.
> +ds2490
> +	- The Maxim/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.


-- 
~Randy
