Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYC2Ek2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYC2Ek2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 00:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYC2EkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 00:40:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:64113 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYC2EkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 00:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Y26SU8PBjvuRr/P+li33/8689Qw6LVrKObhn7cgLc3H9uOScxOmbk6NYvfEWPG8/YrTovbLANJ778CBIQCAAjRBMlKkgLlHc5kMb+9b8K9Pt6ZX15M+M+Lgi1msQJAelFpo8fslRICK2eFCK6/nfGpjNzQtFmWJQcHjOGvyrw80=
Message-ID: <47EDC82C.5070800@gmail.com>
Date: Sat, 29 Mar 2008 13:40:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>
CC: pfps@verizon.net, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-pcmcia@lists.infradead.org
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia, disabling IRQ #9 and Re: libata
 and legacy ide pcmcia failure
References: <20080321011205.4c7b4a61@core>	<47EA5A13.70109@verizon.net>	<47EA6157.6090208@gmail.com> <20080326.112813.200421960.pfps@research.bell-labs.com>
In-Reply-To: <20080326.112813.200421960.pfps@research.bell-labs.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Peter F. Patel-Schneider wrote:
> From: Tejun Heo <htejun@gmail.com>
> Subject: Re: 2.6.23-rc9-git4: pata_pcmcia, disabling IRQ #9 and Re: libata and legacy ide pcmcia failure
> Date: Wed, 26 Mar 2008 23:44:39 +0900
> 
> [Problems with PCMCIA adapter and CF card on ThinkPad T60p.]
> 
>> Does irqpoll help?
> 
> Yes!
> 
> Booting with the irqpoll boot option results in correct behaviour even
> with repeated insertions and removals (with or without unmounting from
> desktop) and when booting with or without the adapter and card inserted.
> Much better (but slower).
> 
> Booting without the irqpoll boot option and no adapter and card in at
> boot results in the bad behaviour when the adapter and card are first
> inserted.  Booting without the irqpoll boot option and the adapter and
> card in at boot results in more-or-less correct behaviour (there is an
> extra icon on the desktop for the media, but this is a known problem and
> probably not related), although in the past the behaviour in this
> situation has been somewhat non-deterministic.
> 
> Problem solved?  Or not?

Well, we're getting somewhere but not really there yet.  Somehow IRQ 
routing didn't get setup right.  I don't have much idea on how to track 
it down.  Cc'ing linux-pci and linux-pcmcia.

Hello, guys, on tp60, IRQ on PCMCIA CF controller isn't working.  I 
don't know whether this is because IRQ isn't routed properly or someone 
didn't wire the ATA interrupt line.  Any ideas?

Thanks.

-- 
tejun
