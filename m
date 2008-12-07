Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbYLGPhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbYLGPhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 10:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYLGPhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 10:37:43 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:40525 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbYLGPhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 10:37:42 -0500
Date: Sun, 7 Dec 2008 16:37:57 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: LibATA error
Message-ID: <20081207153757.GA5761@ics.muni.cz>
References: <20081206185252.GA4323@ics.muni.cz> <493AE09F.5010108@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <493AE09F.5010108@shaw.ca>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 07 Dec 2008 16:37:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 02:29:19PM -0600, Robert Hancock wrote:
>> [  461.382432] ata1.00: exception Emask 0x2 SAct 0x1 SErr 0x2000000 action 0x6
>> frozen
>> [  461.382484] ata1.00: irq_stat 0x00000010, unknown FIS 00000000 00000000
>> 00000000 00000000
>> [  461.382534] ata1: SError: { UnrecFIS }
>> [  461.382572] ata1.00: cmd 61/08:00:0f:82:de/00:00:00:00:00/40 tag 0 ncq 4096
>> out
>> [  461.382574]          res 40/00:00:0f:82:de/00:00:00:00:00/40 Emask 0x2 (HSM
>> violation)
>> [  461.382666] ata1.00: status: { DRDY }
>> [  461.382702] ata1: hard resetting link
>> [  461.700087] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>
>
> It could be.. it means the drive sent the controller a SATA FIS (frame  
> information structure) it didn't recognize.

hm, if I disable NCQ, I do not get these errors. Maybe OCZ SSD disks should be
blacklisted for NCQ?

-- 
Luká¹ Hejtmánek
