Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab0BLEM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 23:12:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35108 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630Ab0BLEM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 23:12:27 -0500
Date: Fri, 12 Feb 2010 15:12:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Buchbinder <adam.buchbinder@gmail.com>,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>
Subject: linux-next: manual merge of the trivial tree with the drm tree
Message-Id: <20100212151223.21746bc7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/gpu/drm/radeon/atombios.h between commit
e97bd974448ce90f8e4720499d84580bcd6a2f7a ("drm/radeon/kms: update
atombios.h to latest upstream") from the drm tree and commit
c9404c9c392d557a4687c4cbda022b03cb787ce9 ("Fix misspelling of "should"
and "shouldn't" in comments") from the trivial tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/radeon/atombios.h
index 6732b5d,2a88029..0000000
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@@ -2781,26 -2264,22 +2781,26 @@@ typedef struct _ATOM_LVDS_INFO_V1
  
  #define ATOM_LVDS_INFO_LAST  ATOM_LVDS_INFO_V12
  
 -typedef struct _ATOM_PATCH_RECORD_MODE {
 -	UCHAR ucRecordType;
 -	USHORT usHDisp;
 -	USHORT usVDisp;
 -} ATOM_PATCH_RECORD_MODE;
 +typedef struct  _ATOM_PATCH_RECORD_MODE
 +{
 +  UCHAR     ucRecordType;
 +  USHORT    usHDisp;
 +  USHORT    usVDisp;
 +}ATOM_PATCH_RECORD_MODE;
  
 -typedef struct _ATOM_LCD_RTS_RECORD {
 -	UCHAR ucRecordType;
 -	UCHAR ucRTSValue;
 -} ATOM_LCD_RTS_RECORD;
 +typedef struct  _ATOM_LCD_RTS_RECORD
 +{
 +  UCHAR     ucRecordType;
 +  UCHAR     ucRTSValue;
 +}ATOM_LCD_RTS_RECORD;
  
- //!! If the record below exits, it shoud always be the first record for easy use in command table!!! 
 -/* !! If the record below exits, it should always be the first record for easy use in command table!!! */
 -typedef struct _ATOM_LCD_MODE_CONTROL_CAP {
 -	UCHAR ucRecordType;
 -	USHORT usLCDCap;
 -} ATOM_LCD_MODE_CONTROL_CAP;
++//!! If the record below exits, it should always be the first record for easy use in command table!!! 
 +// The record below is only used when LVDS_Info is present. From ATOM_LVDS_INFO_V12, use ucLCDPanel_SpecialHandlingCap instead.
 +typedef struct  _ATOM_LCD_MODE_CONTROL_CAP
 +{
 +  UCHAR     ucRecordType;
 +  USHORT    usLCDCap;
 +}ATOM_LCD_MODE_CONTROL_CAP;
  
  #define LCD_MODE_CAP_BL_OFF                   1
  #define LCD_MODE_CAP_CRTC_OFF                 2
