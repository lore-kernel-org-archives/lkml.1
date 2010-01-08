Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024Ab0AHT4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0AHT4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648Ab0AHT4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:56:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab0AHT4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:56:15 -0500
Message-ID: <4B478DBC.6010502@redhat.com>
Date: Fri, 08 Jan 2010 14:55:40 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org
Subject: Re: [PATCH v3 00/12] KVM: Add host swap event notifications for PV
 	guest
References: <1262700774-1808-1-git-send-email-gleb@redhat.com> 	<20100108161828.GA30404@amt.cnet> <4B478689.5020907@redhat.com> <3e8340491001081130v2adb8e07k3b32f7f860daf603@mail.gmail.com>
In-Reply-To: <3e8340491001081130v2adb8e07k3b32f7f860daf603@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 02:30 PM, Bryan Donlan wrote:
> On Fri, Jan 8, 2010 at 2:24 PM, Rik van Riel<riel@redhat.com>  wrote:
>> On 01/08/2010 11:18 AM, Marcelo Tosatti wrote:
>>
>>> - Limit the number of queued async pf's per guest ?
>>
>> This is automatically limited to the number of processes
>> running in a guest :)
>
> Only if the guest is nice and plays by the rules. What is to stop a
> malicious guest from just immediately switching back to userspace and
> kicking off another page-in every time it gets an async PF?

Good point, a malicious guest could do that and ruin
things for everyone.  I guess we do need a limit :)

-- 
All rights reversed.
