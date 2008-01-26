Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYAZSjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYAZSjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 13:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYAZSiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 13:38:54 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:44096
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYAZSix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 13:38:53 -0500
Message-ID: <479B7E2B.9080702@qumranet.com>
Date: Sat, 26 Jan 2008 20:38:35 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] SVM: add module parameter to disable
 Nested Paging
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-4-git-send-email-joerg.roedel@amd.com> <479A561B.8070009@codemonkey.ws> <20080125221029.GA23111@amd.com>
In-Reply-To: <20080125221029.GA23111@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
>>> +static char *npt = "on";
>>> +
>>> +module_param(npt, charp, S_IRUGO);
>>>  
>>>       
>> This would probably be better as an integer.  Then we don't have to do nasty things like 
>> implicitly cast a literal to a char *.
>>     
>
> Hmm, I used int for that first but typing npt=off seemed more
> userfriendly to me than npt=0. So I used char* for it.
>   

I expect this to be rarely used by users, so the simpler int is 
preferable (and also consistent with vmx's bypass_guest_pf and enable_vpid).

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

