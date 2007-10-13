Return-Path: <linux-kernel-owner+w=401wt.eu-S1763339AbXJMWNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763339AbXJMWNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 18:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbXJMWNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 18:13:45 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2538 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbXJMWNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 18:13:44 -0400
X-Greylist: delayed 751 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2007 18:13:44 EDT
Date: Sun, 14 Oct 2007 00:00:51 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, aia21@cantab.net,
       linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NTFS error messages: replace static char pointers by
	static char arrays
Message-ID: <20071013220051.GE25076@vanheusden.com>
References: <470AA75E.7010508@gmail.com> <20071009124035.GA4245@Ahmed> <470BCC5E.9090409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470BCC5E.9090409@gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sun Oct 14 00:32:21 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> The patch below contains a small code clean-up for the NTFS driver: all
>>> static char pointers to error message strings have been replaced by 
>>> static char arrays.

While doing that clean-up, shouldn't these be converted as well?

folkert@muur:/usr/src/linux$ find . -name \*.c -print0 | xargs -0 grep "^ *char *\* *[a-zA-Z0-9_]* *= *\".*\".*;"
./arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c:char *toshiba_name = "";
./arch/ppc/boot/simple/misc-embedded.c:char *bootrom_cmdline = "";
./arch/blackfin/mach-bf561/boards/ezkit.c:char *bfin_board_name = "ADDS-BF561-EZKIT";
./arch/blackfin/mach-bf561/boards/generic_board.c:char *bfin_board_name = "UNKNOWN BOARD";
./arch/blackfin/mach-bf561/boards/tepla.c:char *bfin_board_name = "Tepla-BF561";
./arch/blackfin/mach-bf561/boards/cm_bf561.c:char *bfin_board_name = "Bluetechnix CM BF561";
./arch/blackfin/mach-bf533/boards/ezkit.c:char *bfin_board_name = "ADDS-BF533-EZKIT";
./arch/blackfin/mach-bf533/boards/cm_bf533.c:char *bfin_board_name = "Bluetechnix CM BF533";
./arch/blackfin/mach-bf533/boards/stamp.c:char *bfin_board_name = "ADDS-BF533-STAMP";
./arch/blackfin/mach-bf533/boards/generic_board.c:char *bfin_board_name = "UNKNOWN BOARD";
./arch/blackfin/mach-bf537/boards/stamp.c:char *bfin_board_name = "ADDS-BF537-STAMP";
./arch/blackfin/mach-bf537/boards/generic_board.c:char *bfin_board_name = "UNKNOWN BOARD";
./arch/blackfin/mach-bf537/boards/pnav10.c:char *bfin_board_name = "PNAV-1.0";
./arch/blackfin/mach-bf537/boards/cm_bf537.c:char *bfin_board_name = "Bluetechnix CM BF537";
./arch/blackfin/mach-bf548/boards/ezkit.c:char *bfin_board_name = "ADSP-BF548-EZKIT";
./drivers/net/pcmcia/fmvj18x_cs.c:    char *card_name = "unknown";
./drivers/atm/fore200e_mkfirm.c:char* default_basename = "pca200e"; /* was initially written for the PCA-200E firmware */
./drivers/atm/fore200e_mkfirm.c:char* default_infname  = "<stdin>";
./drivers/atm/fore200e_mkfirm.c:char* default_outfname = "<stdout>";
./drivers/scsi/aic7xxx_old.c:      char *channel = "";
./drivers/scsi/aic7xxx_old/aic7xxx_proc.c:    char *channel = "";
./drivers/scsi/aic7xxx_old/aic7xxx_proc.c:    char *ultra = "";
./drivers/scsi/aic7xxx_old/aic7xxx_proc.c:    char *wide = "Narrow ";
./drivers/isdn/i4l/isdn_ppp.c:char *isdn_ppp_revision = "$Revision: 1.1.2.3 $";
./drivers/isdn/i4l/isdn_tty.c:char *isdn_tty_revision = "$Revision: 1.1.2.3 $";
./drivers/isdn/i4l/isdn_net.c:char *isdn_net_revision = "$Revision: 1.1.2.2 $";
./drivers/isdn/i4l/isdn_audio.c:char *isdn_audio_revision = "$Revision: 1.1.2.2 $";
./drivers/isdn/i4l/isdn_v110.c:char *isdn_v110_revision = "$Revision: 1.1.2.2 $";
./drivers/isdn/hysdn/hysdn_net.c:char *hysdn_net_revision = "$Revision: 1.8.6.4 $";
./drivers/isdn/hardware/eicon/diva_didd.c:char *DRIVERRELEASE_DIDD = "2.0";
./drivers/isdn/hardware/eicon/divasmain.c:char *DRIVERRELEASE_DIVAS = "2.0";
./drivers/isdn/hardware/eicon/divasi.c:char *DRIVERRELEASE_IDI = "2.0";
./drivers/isdn/hardware/eicon/divamnt.c:char *DRIVERRELEASE_MNT = "2.0";
./drivers/serial/mcfserial.c:char *mcfrs_drivername = "ColdFire internal UART serial driver version 1.00\n";


Folkert van Heusden

-- 
MultiTail is a versatile tool for watching logfiles and output of
commands. Filtering, coloring, merging, diff-view, etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
