Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZALNHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZALNHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZALNHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:07:05 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:49335 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751568AbZALNHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:07:03 -0500
Message-ID: <496B4073.4040108@snapgear.com>
Date: Mon, 12 Jan 2009 23:06:59 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       stable@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for 2.6.28 stable] m68knommu: fix m68knommu defconfig
 can't build
References: <20081230193943.1281.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48E9AE16.2000002@snapgear.com> <20090112104447.GG28564@linux-sh.org>
In-Reply-To: <20090112104447.GG28564@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Mon, Oct 06, 2008 at 04:20:06PM +1000, Greg Ungerer wrote:
>> Hi Kosako,
>>
>> KOSAKI Motohiro wrote:
>>> I guess nobody don't test m68knommu at all last three month.
>>> Do we still need to maintain this architecture?
>> Yes, we do.
>>
> Any effort to get m68knommu folded in to m68k proper? This might help

Some :-)
The header merge is the first step.


> with some of your bitrot issues.. And likely less work to do in
> supporting those m68knommu parts that ship with MMUs ;-)
> 
> m68knommu is the only one of the mmu/nommu variants left that ships in
> its own architecture directory rather than being folded in to its parent.
> It would be good to get rid of it one of these days.

Yep. I think we will likely make some progress on this over
the next few months...



-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
