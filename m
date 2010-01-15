Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab0AOVO6 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581Ab0AOVO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:14:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:45094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab0AOVOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:14:55 -0500
Message-ID: <4B50DA78.6050909@kernel.org>
Date: Fri, 15 Jan 2010 13:13:28 -0800
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
Subject: Re: [PATCH 05/14] pci: add failed_list to record failed one for pci_bus_assign_resources
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>	<1261522954-12591-6-git-send-email-yinghai@kernel.org> <20100115105645.085c5e91@jbarnes-piketon>
In-Reply-To: <20100115105645.085c5e91@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 10:56 AM, Jesse Barnes wrote:
> On Tue, 22 Dec 2009 15:02:25 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> so later we can do sth with those failed one
>>
>> -v2: store start, end, flags aside. so could keep res cleared when
>> assign failed. and make following assignment of its children do not
>> go wild
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/setup-bus.c |   66
>> ++++++++++++++++++++++++++++++++++++++++++++--- 1 files changed, 62
>> insertions(+), 4 deletions(-)
> 
> Bjorn's comments still stand here, this patch doesn't make any sense by
> itself.  Either the failed list functions and struct def should stand
> alone, or the whole thing should be rolled into the patch that actually
> makes use of these functions.
> 

just want to make patch to be reviewed easyly.

YH
