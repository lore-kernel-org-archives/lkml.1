Return-Path: <linux-kernel-owner+w=401wt.eu-S1762319AbYBSWG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762319AbYBSWG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYBSWGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:06:48 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:61154 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYBSWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:06:47 -0500
Message-ID: <47BB52B9.5020702@oracle.com>
Date: Tue, 19 Feb 2008 14:05:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: 2.6.25-rc2-mm1 (x64 thermal build failure)
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>	<20080216211603.bb4f3582.randy.dunlap@oracle.com>	<20080216214410.b9699910.akpm@linux-foundation.org>	<20080218111536.511c4fbc@crazy>	<20080218041340.f1e46ec9.akpm@linux-foundation.org>	<20080219165502.2c202759@crazy>	<20080219094147.b9e0e99b.randy.dunlap@oracle.com> <20080219230016.5b7ff43d@crazy>
In-Reply-To: <20080219230016.5b7ff43d@crazy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Petazzoni wrote:
> Le Tue, 19 Feb 2008 09:41:47 -0800,
> Randy Dunlap <randy.dunlap@oracle.com> a écrit :
> 
>> Does this patch apply to -mm?  Seem like No.
> 
> No, it was generated against 2.6.25-rc2.
> 
>> After converting it from mime(?) to ASCII
> 
> Probably due to my PGP-MIME signature. Will try to remember that
> I should disable it next time.
> 
>> and fixing one #if (change "and" to "&&")
> 
> Oops. Fixed on my side too.
> 
>> & fixing patch rejects, it does build cleanly.
> 
> The rejects are probably due to the patch being applied to -mm. It
> applies fine on -rc here.
> 
> Any opinion about whether the patch is clean ? Worth it ?

It seems reasonable to me as long as the option depends on EMBEDDED,
as it does.

-- 
~Randy
