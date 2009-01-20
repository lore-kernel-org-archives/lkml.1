Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbZATN0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbZATN0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbZATN0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:26:16 -0500
Received: from office.neopsis.com ([78.46.209.98]:39244 "EHLO
	office.neopsis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbZATN0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:26:15 -0500
X-Greylist: delayed 1813 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2009 08:26:15 EST
Message-ID: <4975C95F.7000302@dbservice.com>
Date: Tue, 20 Jan 2009 13:53:51 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090117 Shredder/3.0b2pre
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zhao Yakui <yakui.zhao@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Suspned/resume can't work on the 2.6.29-rc1 but it can work	well
 on the 2.6.28
References: <1232413680.3971.32.camel@yakui_zhao.sh.intel.com> <20090120074534.GE16426@elte.hu>
In-Reply-To: <20090120074534.GE16426@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2009 08:45 AM, Ingo Molnar wrote:
> * Zhao Yakui<yakui.zhao@intel.com>  wrote:
>
>> Hi, All
>>      I do some tests about suspend/resume on my two boxes. One is HP
>> laptop and the other is Asus EEEPC901. The suspend/resume can't work
>> well. Even after core is selected as the test mode, it still can't work
>> well.(echo core>  /sys/power/pm_test)
>>
>>      Then I do the same test by using the 2.6.28 kernel. And
>> suspend/resume can work well.
>>
>>      Of course I will try to use the git-bisect to identify the first bad
>> commit ASAP.
>
> make sure you try this patch from Rafael first (it's not on lkml it
> appears - Rafael, mind resending the patch to this thread?):
>
> Subject: [PATCH] PCI PM: Restore standard config registers of all devices early
>          (was: Re: EeePC resume failure - timers)
>

Would that also fix http://bugzilla.kernel.org/show_bug.cgi?id=12492?

I should add that pm_tests freezer, devices and platform work, but
processors fails (I didn't test core since I suppose that when 
processors fails, core will fail as well).

tom

