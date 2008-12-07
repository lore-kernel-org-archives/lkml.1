Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbYLGTvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbYLGTvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 14:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYLGTva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 14:51:30 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:48081 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYLGTv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 14:51:29 -0500
Date: Sun, 7 Dec 2008 20:51:38 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: LibATA error
Message-ID: <20081207195138.GB5761@ics.muni.cz>
References: <20081206185252.GA4323@ics.muni.cz> <493AE09F.5010108@shaw.ca> <20081207153757.GA5761@ics.muni.cz> <20081207183647.3ba03750@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081207183647.3ba03750@lxorguk.ukuu.org.uk>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 07 Dec 2008 20:51:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 06:36:47PM +0000, Alan Cox wrote:
> They shouldn't be claiming they can do NCQ if so. Can you dump out the
> identify data in full (with hdparm) and if possible (or if someone else
> with one can comment..) find out whether the same occurs with different
> controller types.

Controller reports NCQ queue depth 1.

Did you mean this one?

 hdparm -i /dev/sda

/dev/sda:

 Model=OCZ CORE_SSD                            , FwRev=02.10104,
SerialNo=DC030849085600010   
 Config={ Fixed }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=63
 BuffType=unknown, BuffSize=0kB, MaxMultSect=1, MultSect=?1?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=504856576
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4 
 DMA modes:  mdma0 mdma1 mdma2 
 UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5 
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: unknown:  ATA/ATAPI-1,2,3,4,5,6,7

 * signifies the current active mode

-- 
Luká¹ Hejtmánek
