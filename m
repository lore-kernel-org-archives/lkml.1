Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0CIUaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:30:11 -0500
Received: from proxy.quengel.org ([213.146.113.159]:46086 "EHLO
	gerlin1.hsp-law.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751826Ab0CIUaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:30:09 -0500
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Sound MSI fallout on a Asus mobo NVIDIA MCP55
References: <87hboq32lr.fsf@gerlin1.hsp-law.de> <s5hfx49s8rq.wl%tiwai@suse.de>
From: Ralf Gerbig <rge@quengel.org>
Date: Tue, 09 Mar 2010 21:30:07 +0100
In-Reply-To: <s5hfx49s8rq.wl%tiwai@suse.de> (Takashi Iwai's message of "Tue\, 09 Mar 2010 18\:30\:01 +0100")
Message-ID: <87ocixi6gg.fsf@gerlin1.hsp-law.de>
User-Agent: Gnus/5.101 (Gnus v5.10.10) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moins,

* Takashi Iwai writes:

> Applied now.
> But, at the next time, please submit a patch that can be applied directly.
> See Documentation/SubmittingPatches for details.

>> --- a/sound/pci/hda/hda_intel.c
>> +++ b/sound/pci/hda/hda_intel.c
>> @@ -2351,6 +2351,7 @@
>> static struct snd_pci_quirk msi_black_list[] __devinitdata = {
>> SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
>> SND_PCI_QUIRK(0x1043, 0x81f6, "ASUS", 0), /* nvidia */
>> +	SND_PCI_QUIRK(0x1043, 0x822d, "ASUS", 0), /* Athlon64 X2 + nvidia MCP55*/
>> {}
>> };
>> 
>> if you need it: Signed-off-by: Ralf Gerbig <rge@quengel.org>
>> 
>> Ralf
>> 

oops, sorry but I'm not a developer. I did apply this to my tree and
it worked - what went wrong?

thanks,

Ralf
