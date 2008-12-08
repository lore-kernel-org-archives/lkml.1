Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbYLHGMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbYLHGMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 01:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYLHGMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 01:12:45 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:55579 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYLHGMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 01:12:44 -0500
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2008 01:12:44 EST
Message-ID: <493CB8DB.8070105@freemail.hu>
Date: Mon, 08 Dec 2008 07:04:11 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Zhang, Rui" <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org
Subject: Re: AE_ERROR, ACPI thermal trip point state changed
References: <47CF96E2.9020302@freemail.hu> <1204757373.10256.179.camel@acpi-hp-zz.sh.intel.com> <823A93EED437D048963A3697DB0E35DE0129BB78@pdsmsx414.ccr.corp.intel.com> <47D0E694.5050102@freemail.hu> <1204874686.10256.185.camel@acpi-hp-zz.sh.intel.com> <47D24341.5070908@freemail.hu> <1205113940.10256.191.camel@acpi-hp-zz.sh.intel.com> <48ABDF1E.3010101@freemail.hu> <8763pwypf5.fsf@basil.nowhere.org> <49249121.6050304@freemail.hu> <20081119232224.GR6703@one.firstfloor.org>
In-Reply-To: <20081119232224.GR6703@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02a.mail.t-online.hu 32721; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Nov 19, 2008 at 11:20:17PM +0100, Németh Márton wrote:
>> Hi,
>>
>> Andi Kleen wrote:
>>> Németh Márton <nm127@freemail.hu> writes:
>>>> As of 2.6.27-rc3 the patch is still not included in the mainstream. I
>>>> hope that this patch was not forgotten completely.
>>> It's already in Linus' tree, will be in rc4.
>> I compiled and tried 2.6.28-rc5. In the dmesg I get the following message:
>>
>> [   63.589603] ACPI Exception (thermal-0538): AE_ERROR, ACPI thermal trip point state changed
>> [   63.589669] Please send acpidump to linux-acpi@vger.kernel.org
>> [   63.589805]  [20080926]
>>
>> The original patch still applies for 2.6.28-rc5 (with some offsets). This patch
>> is not included in 2.6.28-rc5, yet. The "AE_ERROR..." message does not appear
>> any more if I apply the patch. I attached this original patch for easier reference.
> 
> Hmm sorry I must have confused it with some other patch back then.
> Anyways Len Brown is handling ACPI again now, so he'll have to sort
> it out. cc'ed (the original patch is on linux-acpi)

This is just a status report about 2.6.28-rc7, nothing more. The AE_ERROR
message is still in the dmesg. The patch still solves the problem.

Regards,

	Márton Németh
