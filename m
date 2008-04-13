Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYDMHdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYDMHdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 03:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYDMHdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 03:33:41 -0400
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:17631
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbYDMHdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:33:40 -0400
X-Trace: 94158175/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/83.67.11.44
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AncFAAtUAUhTQwss/2dsb2JhbACBXZB5lwg
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: libata errors with smartctl on 2.6.24, WD3200AAKS and nVidia AHCI
Date: Sun, 13 Apr 2008 08:34:13 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200804092130.07149.tvrtko@ursulin.net> <480179D3.8070707@gmail.com>
In-Reply-To: <480179D3.8070707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804130834.14257.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 April 2008 04:11:15 Tejun Heo wrote:
> Is auto spindown configured for the drive?

I don't think so - it's a 3.5" drive with no special PM features - but how to 
tell?

Tvrtko

root@sol:~# hdparm -i /dev/sda

/dev/sda:

 Model=WDC WD3200AAKS-00VYA0                   , FwRev=12.01B02, SerialNo=     
WD-WCARW0059893
 Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs FmtGapReq }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=50
 BuffType=unknown, BuffSize=16384kB, MaxMultSect=16, MultSect=?0?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7

 * signifies the current active mode

root@sol:~# sdparm -a /dev/sda
    /dev/sda: ATA       WDC WD3200AAKS-0  12.0
Read write error recovery mode page:
  AWRE        1
  ARRE        0
  TB          0
  RC          0
  EER         0
  PER         0
  DTE         0
  DCR         0
  RRC         0
  COR_S       0
  HOC         0
  DSOC        0
  WRC         0
  RTL         0
Caching (SBC) mode page:
  IC          0
  ABPF        0
  CAP         0
  DISC        0
  SIZE        0
  WCE         1
  MF          0
  RCD         0
  DRRP        0
  WRP         0
  DPTL        0
  MIPF        0
  MAPF        0
  MAPFC       0
  FSW         0
  LBCSS       0
  DRA         0
  NV_DIS      0
  NCS         0
  CSS         0
Control mode page:
  TST         0
  TMF_ONLY    0
  D_SENSE     0
  GLTSD       1
  RLEC        0
  QAM         0
  QERR        0
  RAC         0
  UA_INTLCK   0
  SWP         0
  ATO         0
  TAS         0
  AUTOLOAD    0
  BTP        -1
  ESTCT      30
