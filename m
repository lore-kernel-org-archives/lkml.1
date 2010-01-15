Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab0AOVRO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841Ab0AOVRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:17:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:57592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab0AOVRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:17:12 -0500
Message-ID: <4B50DB01.5080602@kernel.org>
Date: Fri, 15 Jan 2010 13:15:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 06/14] pci: reject mmio range start from 0 on pci_bridge
 read
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>	<1261522954-12591-7-git-send-email-yinghai@kernel.org> <20100115111944.00001c2b@jbarnes-piketon>
In-Reply-To: <20100115111944.00001c2b@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 11:19 AM, Jesse Barnes wrote:
> On Tue, 22 Dec 2009 15:02:26 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> that is wrong.
>>
>> exposed by that patch that doesn's shrink pci bridge res.
>>
>> -v2: change to "bar reading" to "reg reading"
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
> 
> Is this really necessary?  Won't we conflict with the reserved zero
> page anyway?
> 

just try to print out the work for pci bridge BAR by BIOS, and just like we did for pci device BAR

before we touch it.

YH
