Return-Path: <linux-kernel-owner+w=401wt.eu-S1751787AbZGWSCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbZGWSCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZGWSCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:02:15 -0400
Received: from mail-px0-f186.google.com ([209.85.216.186]:40009 "EHLO
	mail-px0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZGWSCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:02:14 -0400
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chaithrika U S <chaithrika@ti.com>,
       Pavel Kiryukhin <pkiryukhin@ru.mvista.com>,
       Naresh Medisetty <naresh@ti.com>, Steve Chen <schen@mvista.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Subject: Re: linux-next: manual merge of the sound tree with the davinci tree
References: <20090723112110.e42430e9.sfr@canb.auug.org.au>
	<s5hvdlkvsk6.wl%tiwai@suse.de>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 23 Jul 2009 10:54:44 -0700
In-Reply-To: <s5hvdlkvsk6.wl%tiwai@suse.de> (Takashi Iwai's message of "Thu\, 23 Jul 2009 08\:09\:45 +0200")
Message-ID: <873a8ni8t7.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> writes:

> At Thu, 23 Jul 2009 11:21:10 +1000,
> Stephen Rothwell wrote:
>> 
>> Hi Takashi,
>> 
>> Today's linux-next merge of the sound tree got a conflict in
>> sound/soc/davinci/davinci-evm.c between commit
>> 95d0d986d09ac25a5b9f2bf28f289ab0823e86d5 ("davinci: EDMA: multiple CCs,
>> channel mapping and API changes") from the davinci tree and commit
>> 04f80f5c486b39446af44e218dba90ec210d61ca ("ASoC: Add machine driver
>> support for DM646x") from the sound tree.
>> 
>> The latter removes the code modified by the former.  I have just used the
>> latter.
>
> Thanks.  I'll try to resolve the conflict in the sound tree,
> e.g. pulling the affecting commit of davinci tree into for-next 
> branch.

I've taken care of this in the DaVinci for-next branch.

I dropped the davinci changes that change code that were then dropped
by the asoc changes.

Kevin
