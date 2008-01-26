Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbYAZQgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbYAZQgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYAZQgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 11:36:37 -0500
Received: from hs-out-0708.google.com ([64.233.178.249]:2351 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752460AbYAZQgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:36:36 -0500
Message-ID: <479B619E.3010801@codemonkey.ws>
Date: Sat, 26 Jan 2008 10:36:46 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alexey Eremenko <al4321@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] SVM: add module parameter to disable
 NestedPaging
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>	<1201294393-22613-4-git-send-email-joerg.roedel@amd.com>	<2D848F959C03D945A84E9EDE7F7BFE4274021D@orsmsx424.amr.corp.intel.com>	<20080126072556.GB21476@8bytes.org> <7fac565a0801260149j7d6d48demfb49d2bb0d5a952@mail.gmail.com>
In-Reply-To: <7fac565a0801260149j7d6d48demfb49d2bb0d5a952@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Eremenko wrote:
>> Generally I see no problem with it. But at least for NPT I don't see a
>> reason why someone should want to disable it on a VM basis (as far as it
>> works stable). Avi, what do you think?
>>
>>     
>
> 1. This is more user-friendly and easier-to-find
>   

I'm inclined to disagree.  Why add an additional thing for people to 
tune if they really shouldn't need to.  Once NPT/EPT support are stable, 
is there any reason to want to disable it?

Regards,

Anthony Liguori

> 2. A lot of people would like to view (and Demo) it side-by-side.
>
> 3. Useful for BETA-testing of KVM.
>
>   

