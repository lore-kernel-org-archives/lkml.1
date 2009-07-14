Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZGNQHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZGNQHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZGNQHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:07:11 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:61910 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbZGNQHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:07:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19036.44270.548043.875878@stoffel.org>
Date: Tue, 14 Jul 2009 12:06:06 -0400
From: "John Stoffel" <john@stoffel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, John Stoffel <john@stoffel.org>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 5/5] Make SCSI SG v4 driver enabled by default and
 remove EXPERIMENTAL dependency, since udev depends on BSG.
In-Reply-To: <1247578141.4310.34.camel@mulgrave.site>
References: <1247513973-24899-1-git-send-email-john@stoffel.org>
	<19035.36432.181354.977939@stoffel.org>
	<4A5C27D4.5040204@panasas.com>
	<1247578141.4310.34.camel@mulgrave.site>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> On Tue, 2009-07-14 at 09:38 +0300, Boaz Harrosh wrote:
>> On 07/13/2009 10:43 PM, John Stoffel wrote:
>> >>>>>> "John" == John Stoffel <john@stoffel.org> writes:
>> > 
>> > Dammit, I messed up here sending this patch.  I've just edited the
>> > subject line and re-sent it with a bit more description.  I think this
>> > patch is perfectly good to go into 2.6.31 right now, esp since it's
>> > not changing code, just whether the code is turned on by default from
>> > now on.
>> > 
>> 
>> I would like it if you'd also CC stable@kernel.org on this patch. As this
>> condition is already true for distros in the field.

James> The stable tree is for bug *fixes*.  Moving an option out from
James> under experimental is basically an enhancement, even if it
James> could be argued it should have been done long ago.

I'm not so sure I agree with this, since this feature is used by UDEV
and has been enabled by default on a bunch of distros for ages (as I'm
told, personally I haven't confirmed this).

But if you object to stable back porting, what are you feelings on
this change for 2.6.31-rc* now?  Do you think it needs to be held off
and that it's too late to make this change?

Thanks,
John


