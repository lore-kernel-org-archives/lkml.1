Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYFCA2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYFCA2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 20:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYFCA1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 20:27:52 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:59850 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbYFCA1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 20:27:51 -0400
Message-ID: <484490D1.2040303@keyaccess.nl>
Date: Tue, 03 Jun 2008 02:31:13 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bjorn.helgaas@hp.com, torvalds@linux-foundation.org, avuton@gmail.com,
       rene.herman@gmail.com, len.brown@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my
 ALSA intel8x0 sound card regression
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>	<200806021605.14519.bjorn.helgaas@hp.com>	<3aa654a40806021523k5b89cd0cjbcddf5810d05072b@mail.gmail.com>	<200806021642.50491.bjorn.helgaas@hp.com>	<20080602164954.2aff2d77.akpm@linux-foundation.org>	<48448932.80803@keyaccess.nl> <20080602170309.6f9aea47.akpm@linux-foundation.org>
In-Reply-To: <20080602170309.6f9aea47.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-06-08 02:03, Andrew Morton wrote:

> On Tue, 03 Jun 2008 01:58:42 +0200
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> On 03-06-08 01:49, Andrew Morton wrote:
>>
>>> This broke
>>> pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch:
>> I expect the patch was meant solely for 2.6.26...
> 
> Sure.  When this patch
> (pnp-mark-resources-that-conflict-with-pci-devices-disabled.patch) is
> applied to 2.6.26, the for-2.6.27
> pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
> broke, as I described here.

Err, yes, got them mixed up. There are just so many of them -- after .27 
Bjorn will have basically rewritten all of PnP...

>> Bjorn, before you repost the option series due to this, wait a minute. 
>> Am now looking at/testing 14/15 and see some stuff that needs changing 
>> as well.
> 
> "the option series" == "PNP: convert resource options to unified
> dynamic list, v1".
> 
> I haven't got onto that yet.  Strategic lagginess is working out
> nicely.

My bloody ISA test machine decided to up and die on me during a BIOS 
flash. I'm sitting right smack in the middle of huge heap of old ISA 
gunk hardware, cases and motherboards here -- and now I have to try and 
dig out my bed ... :-(

Rene.


