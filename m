Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbZF2UZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbZF2UZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZF2UY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:24:56 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49878 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZF2UY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:24:56 -0400
Message-ID: <4A492316.4030502@monstr.eu>
Date: Mon, 29 Jun 2009 22:24:54 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: grant.likely@secretlab.ca, arnd@arndb.de, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: Move of_node_to_nid to generic location
References: <4A4884D6.3090404@monstr.eu>	<fa686aa40906290852g42f55390tae7148e08fb8efe3@mail.gmail.com> <20090629.131445.77994386.davem@davemloft.net>
In-Reply-To: <20090629.131445.77994386.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> Date: Mon, 29 Jun 2009 09:52:44 -0600
> 
>> On Mon, Jun 29, 2009 at 3:09 AM, Michal Simek<monstr@monstr.eu> wrote:
>>> This function is used for powerpc, sparc, microblaze (and maybe future arm?)
>> PowerPC uses it.  Other than that I don't know.
> 
> Sparc64 definitely uses it.

of_node_nid is called from of_device_register function and could be used by all "fdt" arch.
Anyway I think that we found a solution for it.
Grant can you please incorporate this changes to your patches (just move implementation for non NUMA
systems)?
IMHO of_device.h is the best one.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
