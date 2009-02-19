Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbZBSXaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbZBSXaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 18:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZBSXaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 18:30:23 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40154 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbZBSXaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 18:30:21 -0500
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <m1ocx5ve8o.fsf@fess.ebiederm.org>
	<20090219120333.af992d9e.akpm@linux-foundation.org>
	<m163j61706.fsf@fess.ebiederm.org> <200902192247.46370.rjw@sisk.pl>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Feb 2009 15:30:39 -0800
In-Reply-To: <200902192247.46370.rjw@sisk.pl> (Rafael J. Wysocki's message of "Thu\, 19 Feb 2009 22\:47\:45 +0100")
Message-ID: <m13aeaxaw0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;"Rafael J. Wysocki" <rjw@sisk.pl>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: marc.info]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pcie_portdriver: FIX: pcie_port_device_remove
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Thursday 19 February 2009, Eric W. Biederman wrote:
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>> >
>> > There are large-scale and conflicting changes to this file in linux-next.
>> >
>> > If we want to jam this fix into 2.6.29 (and it looks like something we
>> > want) then this will trash the linux-next changes.  It will cause me
>> > grief, and will cause Stephen grief unless the pci tree is suitably
>> > changed, which will cause Jesse grief. Either way: grief.
>> 
>> Ugh.
>> 
>> I had better have a good hard look at linux-next.  I tried to ask earlier
> about
>> ongoing working but I didn't hear anything.
>
> Yes, you did: http://marc.info/?l=linux-kernel&m=123342565225134&w=4

My apologies.  I should have said I did not recognize anything that
was likely to conflict from what I hear from what I heard.  I did
hear that the pcie port driver was touched to properly handle msi-x and I
foolishly thought that was already merged upstream.  Especially after
I glanced at Jesse's tree and I did not see any recent pci patches.
Which led me to foolishly assume everything had already been merged
into Linus's tree.

Andrew with respect to 2.6.29 my patch while correct and useful has
no immediate utility, as the pciehp driver will crash and burn horribly
if you attempt to hotplug it.  So I should find the other pci port driver
changes and rebase on top of them.  Assuming that patch is scheduled to
merge for 2.6.30.

Eric


