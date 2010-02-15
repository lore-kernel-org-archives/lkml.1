Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0BODvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 22:51:32 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:39837 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0BODva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 22:51:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=gIvd2if+sv2Rv9YzPkc2imNVZ1oJZpkUJDRUDS+DbC7IgaxNxvRZ4NX/wvTtsHPXfh
         0x8XUKBE59Pj2PpQcfZSggMIiPRHxgVizd/8077ZrU11BJWgW7kBRfA4D3gPOZ2+MGEr
         1lCc/m6CLiDLIm34C+AX2y/qzSiISwoVmWaoI=
Message-ID: <4B78C4BF.1000908@lwfinger.net>
Date: Sun, 14 Feb 2010 21:51:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] staging: r8187se: Miscellaneous cleanups
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches comprise further cleanups of the staging driver.

1. Remove dead routine from r8180_core.c.

2. Remove two private variables that have a fixed value.

3. Remove dead code from r8185b_init.c.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Patch 1:

 r8180_core.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)

Patch 2:

 r8180.h           |    4
 r8180_core.c      |   90 -------------
 r8180_dm.c        |   71 ++--------
 r8180_rtl8225z2.c |  238 +++++++++++++++-------------------
 r8185b_init.c     |  368 +++++++++++-------------------------------------------
 5 files changed, 197 insertions(+), 574 deletions(-)

Patch 3:

 r8185b_init.c |  633 ----------------------------------------------------------
 1 file changed, 2 insertions(+), 631 deletions(-)



