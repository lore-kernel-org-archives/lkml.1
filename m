Return-Path: <linux-kernel-owner+w=401wt.eu-S1751685Ab0ADLnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab0ADLnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 06:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778Ab0ADLnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 06:43:11 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:39982 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0ADLnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 06:43:09 -0500
Message-ID: <4B41D42A.9040008@xenontk.org>
Date: Mon, 04 Jan 2010 17:12:34 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: jbarnes@virtuousgeek.org, andreas.herrmann3@amd.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Check the node argument passed to cpumask_of_node
References: <201001012255.28094.rjw@sisk.pl> <1262412947-3890-1-BlackWidow-davidjon@xenontk.org> <201001041458.24145.rusty@rustcorp.com.au>
In-Reply-To: <201001041458.24145.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 09:58 AM, Rusty Russell wrote:
> On Sat, 2 Jan 2010 04:45:47 pm David John wrote:
>> Commit e0cd516 "PCI: derive nearby CPUs from device's instead of bus' NUMA information"
>> causes an null pointer dereference when reading from the sysfs attributes local_cpu*
>> on Intel machines with no ACPI NUMA proximity info, since dev->numa_node gets set to -1
>> for all PCI devices, which then gets passed to cpumask_of_node.
>>
>> Ensure that the node value is valid.
> 
> This only works for x86, and only for !CONFIG_DEBUG_PER_CPU_MAPS.
> 
> I suggest fixing the callers introduced in e0cd516 for the moment,
> then if you feel enthused, change the semantics of cpumask_of_node and
> remove the checks from the various callers.

Okay, I'll do as you suggested.

Regards,
David.
