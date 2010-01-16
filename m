Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0APJgS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510Ab0APJgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:36:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:39666 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab0APJgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:36:11 -0500
Message-ID: <4B518815.70006@kernel.org>
Date: Sat, 16 Jan 2010 01:34:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/11] pciehp: add support for bridge resource	reallocation
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org> <1263609721-3921-11-git-send-email-yinghai@kernel.org> <20100116045911.GI22215@ldl.fc.hp.com>
In-Reply-To: <20100116045911.GI22215@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 08:59 PM, Alex Chiang wrote:
> * Yinghai Lu <yinghai@kernel.org>:
>> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>>
>> With this patch, pciehp driver try to clear PCI bridge resources to
>> parent bridge (root port or switch downstream port) of the slot
>>
>> so we can shrink pci bridge resource for those port
>>
>> This feature is enabled when 'pciehp_realloc' option is specified.
>>
>> -v2: make it could be appiled after Yinghai patchset that touch pci bridge
>>      resource also remove poweron check, because pci_bridge_release_res will
>>      check child at first
> 
> Same comment as my earlier patch. Why not just make this the
> default behavior, instead of introducing yet another command line
> parameter for users to guess at?

it will break Eric's setup/

YH
