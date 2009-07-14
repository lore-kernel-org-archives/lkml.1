Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbZGNOMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbZGNOMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZGNOMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:12:17 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:1979
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753797AbZGNOMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:12:17 -0400
Message-ID: <4A5C923B.9090109@panasas.com>
Date: Tue, 14 Jul 2009 17:12:11 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: John Stoffel <john@stoffel.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 5/5] Make SCSI SG v4 driver enabled by default and remove
 EXPERIMENTAL dependency, since udev depends on BSG.
References: <1247513973-24899-1-git-send-email-john@stoffel.org>	 <19035.36432.181354.977939@stoffel.org>  <4A5C27D4.5040204@panasas.com> <1247578141.4310.34.camel@mulgrave.site>
In-Reply-To: <1247578141.4310.34.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 14:12:14.0823 (UTC) FILETIME=[16858770:01CA048D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2009 04:29 PM, James Bottomley wrote:
> On Tue, 2009-07-14 at 09:38 +0300, Boaz Harrosh wrote:
>> On 07/13/2009 10:43 PM, John Stoffel wrote:
>>>>>>>> "John" == John Stoffel <john@stoffel.org> writes:
>>> Dammit, I messed up here sending this patch.  I've just edited the
>>> subject line and re-sent it with a bit more description.  I think this
>>> patch is perfectly good to go into 2.6.31 right now, esp since it's
>>> not changing code, just whether the code is turned on by default from
>>> now on.
>>>
>> I would like it if you'd also CC stable@kernel.org on this patch. As this
>> condition is already true for distros in the field.
> 
> The stable tree is for bug *fixes*.   Moving an option out from under
> experimental is basically an enhancement, even if it could be argued it
> should have been done long ago.
> 

wouldn't you consider it a bug if a low-level plumbing like Udev is shipped
with hard dependency on it?

if Udev was part of Kconfig it would have a "depend" on bsg. But because
it's a different product it can only rely on defaults?

> James
> 
> 

Thanks
Boaz
