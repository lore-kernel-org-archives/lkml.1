Return-Path: <linux-kernel-owner+w=401wt.eu-S1161824AbXECKhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161824AbXECKhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161826AbXECKhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:37:48 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49952 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161824AbXECKhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:37:47 -0400
X-Originating-Ip: 72.143.66.196
Date: Thu, 3 May 2007 06:37:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead CONFIG_ variables:  drivers/media/
Message-ID: <Pine.LNX.4.64.0705030636140.32764@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


$ ../dead_config.sh drivers/media
========== BIGPHYS_AREA ==========
drivers/media/video/zoran_driver.c:185:// RJ: Test only - want to test BUZ_USE_HIMEM even when CONFIG_BIGPHYS_AREA is defined
drivers/media/video/zoran_driver.c:186:#if !defined(CONFIG_BIGPHYS_AREA)
drivers/media/video/zoran_driver.c:187://#undef CONFIG_BIGPHYS_AREA
drivers/media/video/zoran_driver.c:191:#if defined(CONFIG_BIGPHYS_AREA)
drivers/media/video/zoran_driver.c:253:#if defined(BUZ_USE_HIMEM) && !defined(CONFIG_BIGPHYS_AREA)
drivers/media/video/zoran_driver.c:326:#if defined(BUZ_USE_HIMEM) && !defined(CONFIG_BIGPHYS_AREA)
drivers/media/video/zoran_driver.c:372:#if defined(CONFIG_BIGPHYS_AREA)
drivers/media/video/zoran_driver.c:488:#if defined(CONFIG_BIGPHYS_AREA)
========== DVB_DIBCOM_DEBUG ==========
drivers/media/dvb/frontends/dib3000mb.c:42:#ifdef CONFIG_DVB_DIBCOM_DEBUG
drivers/media/dvb/frontends/dib3000mb.c:55:#ifdef CONFIG_DVB_DIBCOM_DEBUG
drivers/media/dvb/frontends/dib3000mb_priv.h:40:#ifdef CONFIG_DVB_DIBCOM_DEBUG
========== LIRC_I2C ==========
drivers/media/video/ivtv/ivtv-driver.h:70:#ifdef CONFIG_LIRC_I2C
drivers/media/video/ivtv/ivtv-driver.h:72:#endif /* CONFIG_LIRC_I2C */
========== UST ==========
drivers/media/video/v4l2-common.c:69:#if defined(CONFIG_UST) || defined(CONFIG_UST_MODULE)
drivers/media/video/v4l2-common.c:69:#if defined(CONFIG_UST) || defined(CONFIG_UST_MODULE)
sound/oss/vwsnd.c:247:  spinlock_t      lock;           /* protects codec and UST/MSC access */
sound/oss/vwsnd.c:420:#define LI_AUDIO1_UST             0x300   /* UST-MSC pairs */
sound/oss/vwsnd.c:423:#define LI_AUDIO2_MSC             0x30C   /* processed as of time UST */
sound/oss/vwsnd.c:512: * ustmsc is a UST/MSC pair (Unadjusted System Time/Media Stream Counter).
sound/oss/vwsnd.c:513: * UST is time in microseconds since the system booted, and MSC is a
sound/oss/vwsnd.c:750:/* li_read_USTMSC() returns a UST/MSC pair for the given channel. */
========== VIDEO_PROC_FS ==========
drivers/media/video/usbvideo/vicam.c:421:#if defined(CONFIG_VIDEO_PROC_FS)
drivers/media/video/usbvideo/vicam.c:1068:#if defined(CONFIG_VIDEO_PROC_FS)
========== VIVI_SCATTER ==========
drivers/media/video/vivi.c:148:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:235:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:270:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:281:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:308:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:364:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:405:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:418:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:425:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:444:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:720:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:770:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:840:#ifdef CONFIG_VIVI_SCATTER
drivers/media/video/vivi.c:1262:#ifdef CONFIG_VIVI_SCATTER

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
