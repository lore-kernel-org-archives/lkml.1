Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZEZPsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZEZPsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZEZPry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:47:54 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:34733 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbZEZPrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:47:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=uR6IRAg3RYP2oUmJHhnID6gfGa1NtUZSVuGFqExvJlneK7fh9JPgsnnnzvOVEKv59v
         opAndmcpXT701IgpyxgPsC3wOAKTk5rf8XUGUV5tLQsnDBq7XuouJ7WVANOK+YFd12m+
         8oVjooodBK2iQMiA8xBQWE3itMmFBVhv6b4HY=
Date: Tue, 26 May 2009 19:47:47 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Staging: rtl8192su: remove dos style EOL
Message-ID: <20090526154747.GA14893@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Could you please run dos2unix on patch which adds
drivers/staging/rtl8192su before it will be in Linus's git.

I do not like to send a patch like this:

 drivers/staging/rtl8192su/dot11d.h                 |  204 +-
 drivers/staging/rtl8192su/ieee80211/EndianFree.h   |  398 +-
 drivers/staging/rtl8192su/ieee80211/dot11d.c       |  478 +-
 drivers/staging/rtl8192su/ieee80211/dot11d.h       |  204 +-
 drivers/staging/rtl8192su/ieee80211/rtl819x_BA.h   |  138 +-
 .../staging/rtl8192su/ieee80211/rtl819x_BAProc.c   | 1562 ++--
 drivers/staging/rtl8192su/ieee80211/rtl819x_HT.h   | 1034 +-
 .../staging/rtl8192su/ieee80211/rtl819x_HTProc.c   | 4074 ++++----
 drivers/staging/rtl8192su/ieee80211/rtl819x_Qos.h  | 1498 ++--
 drivers/staging/rtl8192su/ieee80211/rtl819x_TS.h   |  112 +-
 .../staging/rtl8192su/ieee80211/rtl819x_TSProc.c   | 1334 ++--
 drivers/staging/rtl8192su/r8192SU_HWImg.c          | 9804 ++++++++++----------
 drivers/staging/rtl8192su/r8192SU_HWImg.h          |   88 +-
 drivers/staging/rtl8192su/r8192S_Efuse.c           | 4884 +++++-----
 drivers/staging/rtl8192su/r8192S_Efuse.h           |  202 +-
 drivers/staging/rtl8192su/r8192S_FwImgDTM.h        | 7594 ++++++++--------
 drivers/staging/rtl8192su/r8192S_firmware.c        | 2046 ++--
 drivers/staging/rtl8192su/r8192S_phy.c             |10056 ++++++++++----------
 drivers/staging/rtl8192su/r8192S_phy.h             |  276 +-
 drivers/staging/rtl8192su/r8192S_phyreg.h          | 2066 ++--
 drivers/staging/rtl8192su/r8192S_rtl8225.c         |  584 +-
 drivers/staging/rtl8192su/r8192U_dm.c              | 9042 +++++++++---------
 drivers/staging/rtl8192su/r8192U_dm.h              |  618 +-
 drivers/staging/rtl8192su/r819xU_HTGen.h           |   44 +-
 drivers/staging/rtl8192su/r819xU_HTType.h          |  784 +-
 drivers/staging/rtl8192su/r819xU_cmdpkt.c          | 1500 ++--
 drivers/staging/rtl8192su/r819xU_cmdpkt.h          |  438 +-
 drivers/staging/rtl8192su/r819xU_firmware_img.c    | 6894 +++++++-------
 drivers/staging/rtl8192su/r819xU_phy.c             | 3652 ++++----
 drivers/staging/rtl8192su/r819xU_phy.h             |  188 +-
 drivers/staging/rtl8192su/r819xU_phyreg.h          | 1742 ++--
 31 files changed, 36769 insertions(+), 36769 deletions(-)

