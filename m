Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbXE3ITJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbXE3ITJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbXE3ISw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:18:52 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:52765 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbXE3ISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:18:50 -0400
Message-ID: <465D3141.305@linux.vnet.ibm.com>
Date: Wed, 30 May 2007 13:39:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: menage@google.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
References: <20070529130104.461765000@menage.corp.google.com> <20070530001455.45cf1dc5.akpm@linux-foundation.org>
In-Reply-To: <20070530001455.45cf1dc5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 29 May 2007 06:01:04 -0700 menage@google.com wrote:
> 
>> This is an update to my multi-hierarchy multi-subsystem generic
>> process containers patch.
>>
>> ...
>>
>> Still TODO:
>>
>> ...
>>
>> - lots more testing
>>
> 
> So how do we do this?
> 
> Is there any sneaky way in which we can modify the kernel so that this new
> code gets exercised more?  Obviously, tossing init into some default
> system-wide container would be a start.  But I wonder if we can be
> sneakier - for example, create a new container on each setuid(), toss the
> task into that.  Or something along those lines?

Please, lets get the RSS controller in. It's ready, been tested
and commented on widely.

I'll also start porting my containerstats patches on top of -v10.

-- 
	Thanks,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
