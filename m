Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbYCWDrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbYCWDrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 23:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbYCWDrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 23:47:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803AbYCWDrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 23:47:17 -0400
Message-ID: <47E5D0F5.50101@redhat.com>
Date: Sat, 22 Mar 2008 23:39:33 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-ohci: catch self_id_count == 0
References: <tkrat.b99824b37365e037@s5r6.in-berlin.de> <tkrat.00038248cbf40b77@s5r6.in-berlin.de> <tkrat.a46eb70f34367db6@s5r6.in-berlin.de> <tkrat.463115f5f3763a98@s5r6.in-berlin.de> <tkrat.8492f68de2af250b@s5r6.in-berlin.de> <tkrat.8f4d95b45b232823@s5r6.in-berlin.de> <47E4DD50.9050706@s5r6.in-berlin.de>
In-Reply-To: <47E4DD50.9050706@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Stefan Richter wrote:
>> fw_core_handle_bus_reset() incorrectly relied on the assumption that
>> self_id_count > 0.
> 
> Even though
>     firewire: insist on successive self ID complete events
>     firewire: fw-ohci: add self ID error check
>     firewire: fw-ohci: catch self_id_count == 0
> didn't fix any of Jarod's weird setups, I plan on submitting these 
> patches nevertheless (after 2.6.25) because they IMO fix real 
> possibilities for panics in the topology code.

Agreed, they all looked valid and didn't cause any regressions in my own 
prodding. So go ahead with all three:

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
