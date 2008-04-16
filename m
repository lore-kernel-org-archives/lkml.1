Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbYDPM7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbYDPM7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYDPM7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:59:07 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:55627
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbYDPM7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:59:06 -0400
Message-ID: <4805F64A.5070800@qumranet.com>
Date: Wed, 16 Apr 2008 15:51:22 +0300
From: Izik Eidus <izike@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: weigelt@metux.de, linux kernel list <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Automatic page sharing/consolidation
References: <20080416013033.GA3057@nibiru.local> <4805E5E9.4080402@qumranet.com>
In-Reply-To: <4805E5E9.4080402@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Enrico Weigelt wrote:
>> Hi folks,
>>
>> I'm using dozens of VE's / jails to separate applications
>> (even complete webapps w/ their own httpd) for easier maintenance
>> and better security. But this tends to consume a lot of memory,
>> since code sharing (.so's) cannot take effect here (each jail/VE
>> has it's completely own tree).
>> Now I wonder if it might be possible to let the kernel automatically
>> find out equal pages and map them together.
>> A little compasion showed up that at least 50% of the code could be
>> shared (maybe more with some tuning, and maybe even data). So it's
>> (IMHO) really worth it.
>>
>> Would this be possible ? What had to be done for this ?
>>   
> 
> Izik (copied) is working on this for kvm.  Results so far are very
> encouraging, but currently merged pages are not swappable.
> 
we have module that posted with kernel patchs in the mm list, you can actualy run it and play with it
there were some bugs that we fixed with it, but i am still not sending it, beacuse i change there quite alot of things
in order to get swapping possible for the pages that are shared.
-- 
woof.
