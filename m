Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311Ab0ARIiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0ARIiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197Ab0ARIiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:38:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45270 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab0ARIiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:38:07 -0500
Message-ID: <4B541D08.9040802@zytor.com>
Date: Mon, 18 Jan 2010 00:34:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
References: <1262700774-1808-1-git-send-email-gleb@redhat.com> <1262700774-1808-5-git-send-email-gleb@redhat.com> <1263490267.4244.340.camel@laptop> <20100117144411.GI31692@redhat.com>
In-Reply-To: <20100117144411.GI31692@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2010 06:44 AM, Gleb Natapov wrote:
> On Thu, Jan 14, 2010 at 06:31:07PM +0100, Peter Zijlstra wrote:
>> On Tue, 2010-01-05 at 16:12 +0200, Gleb Natapov wrote:
>>> Allow paravirtualized guest to do special handling for some page faults.
>>>
>>> The patch adds one 'if' to do_page_fault() function. The call is patched
>>> out when running on physical HW. I ran kernbech on the kernel with and
>>> without that additional 'if' and result were rawly the same:
>>
>> So why not program a different handler address for the #PF/#GP faults
>> and avoid the if all together?
> I would gladly use fault vector reserved by x86 architecture, but I am
> not sure Intel will be happy about it.
>

That's what it's there for... see Peter Z.'s response.

	-hpa
