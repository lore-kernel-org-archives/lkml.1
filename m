Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbZCaHct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbZCaHct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbZCaHcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:32:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36664 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbZCaHci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:32:38 -0400
Message-ID: <49D1C70D.3070509@jp.fujitsu.com>
Date: Tue, 31 Mar 2009 16:32:29 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 3/3] x86, mce: Add mce=nopoll option to disable timer
 polling
References: <49CB3F4B.8070406@jp.fujitsu.com> <49CB4453.6000407@linux.intel.com> <49CCA122.8070908@jp.fujitsu.com> <49CCBC07.6000004@linux.intel.com> <49D08BC7.6070002@jp.fujitsu.com> <49D09188.5060807@linux.intel.com>
In-Reply-To: <49D09188.5060807@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> How to prevent banks from clearing?
> 
> Firmware first typically means the firmware gets it one way or another
> using SMI and that tends to work even when the OS clears because
> SMI comes first. So stopping the clearing is probably not needed?

SMI is not only way for firmware.
IIRC, I heard there are some server doing poll from service processor on
BMC (Board Management Controller).
I could be wrong, but always there could be a special case.

Thanks,
H.Seto

