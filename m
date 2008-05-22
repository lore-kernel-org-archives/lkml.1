Return-Path: <linux-kernel-owner+w=401wt.eu-S1765290AbYEVVQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765290AbYEVVQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764363AbYEVVQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:16:21 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:55504 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761782AbYEVVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:16:19 -0400
Message-ID: <4835E337.4050501@keyaccess.nl>
Date: Thu, 22 May 2008 23:18:47 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 2/4] PNP: replace pnp_resource_table with dynamically
 allocated resources
References: <20080515220726.029505668@ldl.fc.hp.com> <20080515220754.684738602@ldl.fc.hp.com> <483209BF.3040208@keyaccess.nl> <200805191741.16488.bjorn.helgaas@hp.com>
In-Reply-To: <200805191741.16488.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-05-08 01:41, Bjorn Helgaas wrote:

> On Monday 19 May 2008 05:14:07 pm Rene Herman wrote:

>>>  static void pnp_clean_resource_table(struct pnp_dev *dev)

[ ... ]

>> Do correct me if I'm wrong but I don't believe this will do. The index 
>> for the resources is preserved simply due to the list position after the 
>> DISABLED thing but here the list is reshuffled.
>>
>> So say I have an ISAPnP device with 2 port resources the second of which 
>> I force to manual setting through sysfs (ie, AUTO is cleared). This API 
>> would then delete the first port resource after which the second port 
>> resource is the first entry in the list which would make for example 
>> isapnp_set_resource() program it into hardware index 1, no?
> 
> My reasoning was that all AUTO entries should be at the end of the
> list, so deleting them should not change the order of other entries.

Yes, so it seems. You even said that in the changelog. Missed it, sorry.

Acked-by: Rene Herman <rene.herman@gmail.com>

I have had your v2 series running on two machines (using PnPBIOS and 
ISAPnP) for a few days now and I haven't seen anything wrong. Looking 
good therefore. Good stuff!

Rene.
