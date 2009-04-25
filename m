Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZDYJ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZDYJ2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 05:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZDYJ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 05:28:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46908 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZDYJ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 05:28:08 -0400
Date: Sat, 25 Apr 2009 12:28:06 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Greg KH <gregkh@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: staging indentation & braces disagreement list
Message-ID: <Pine.LNX.4.64.0904251221060.22716@wrl-59.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Below is a list from my braces vs indentation pipeline against  
staging (mainline 0c8454f56623)... Plenty of add-bracing/reindentation 
required but I'm busy elsewhere so I leave it up to somebody who wants
to eyeball the code to see which of the alternatives is the
right one. Please disregard the line numbers, they don't match
with the source because the source was trimmed beforehand.


-- 
 i.

drivers/staging/frontier/tranzport.c
183
	if (dev->offline == 2 && dev->interrupt_in_buffer[1] == 0xff)
		goto resubmit;
		if (dev->offline == 1 && dev->interrupt_in_buffer[1] == 0xff) {
			dev->offline = 2;
--
drivers/staging/otus/ioctl.c
242
		else
			iwe.u.mode = IW_MODE_ADHOC;
			current_ev = iwe_stream_add_event(info,	current_ev,
						end_buf, &iwe, IW_EV_UINT_LEN);
--
drivers/staging/rt2860/common/mlme.c
5159
					else
						DBGPRINT_RAW(RT_DEBUG_TRACE,("AsicAdjustTxPower (i/j=%d/%d, Value=%d, %d, no change)\n", i, j, Value, AdjustMaxTxPwr[i*8+j]));
						TxPwr[i] = (TxPwr[i] & ~(0x0000000F << j*4)) | (Value << j*4);
				}
--
drivers/staging/rt2860/common/rtmp_init.c
2650
		if (pTimer->State == FALSE)
			pTimer->Repeat = FALSE;
			RTMP_OS_Del_Timer(&pTimer->TimerObj, pCancelled);
		if (*pCancelled == TRUE)
--
drivers/staging/rt2860/rt_profile.c
1202
							else
								pAd->StaCfg.bTGnWifiTest = TRUE;
								DBGPRINT(RT_DEBUG_TRACE, ("TGnWifiTest=%d\n", pAd->StaCfg.bTGnWifiTest));
						}
--
drivers/staging/rt2870/common/mlme.c
5111
					else
						DBGPRINT_RAW(RT_DEBUG_TRACE,("AsicAdjustTxPower (i/j=%d/%d, Value=%d, %d, no change)\n", i, j, Value, AdjustMaxTxPwr[i*8+j]));
						TxPwr[i] = (TxPwr[i] & ~(0x0000000F << j*4)) | (Value << j*4);
				}
--
drivers/staging/rt2870/common/rtmp_init.c
2837
		if (pTimer->State == FALSE)
			pTimer->Repeat = FALSE;
			RTMP_OS_Del_Timer(&pTimer->TimerObj, pCancelled);
		if (*pCancelled == TRUE)
--
drivers/staging/rt2870/common/rtusb_io.c
533
	if ((status != NDIS_STATUS_SUCCESS) || (cmdqelmt == NULL))
		return (NDIS_STATUS_RESOURCES);
		cmdqelmt->buffer = NULL;
		if (pInformationBuffer != NULL)
--
drivers/staging/rt2870/rt_profile.c
1206
							else
								pAd->StaCfg.bTGnWifiTest = TRUE;
								DBGPRINT(RT_DEBUG_TRACE, ("TGnWifiTest=%d\n", pAd->StaCfg.bTGnWifiTest));
						}
--
drivers/staging/rt3070/common/mlme.c
5366
					else
						DBGPRINT_RAW(RT_DEBUG_TRACE,("AsicAdjustTxPower (i/j=%d/%d, Value=%d, %d, no change)\n", i, j, Value, AdjustMaxTxPwr[i*8+j]));
						TxPwr[i] = (TxPwr[i] & ~(0x0000000F << j*4)) | (Value << j*4);
				}
--
drivers/staging/rt3070/common/rtmp_init.c
2916
		if (pTimer->State == FALSE)
			pTimer->Repeat = FALSE;
			RTMP_OS_Del_Timer(&pTimer->TimerObj, pCancelled);
		if (*pCancelled == TRUE)
--
drivers/staging/rt3070/common/rtusb_io.c
487
	if ((status != NDIS_STATUS_SUCCESS) || (cmdqelmt == NULL))
		return (NDIS_STATUS_RESOURCES);
		cmdqelmt->buffer = NULL;
		if (pInformationBuffer != NULL)
--
drivers/staging/rt3070/rt_profile.c
1207
							else
								pAd->StaCfg.bTGnWifiTest = TRUE;
								DBGPRINT(RT_DEBUG_TRACE, ("TGnWifiTest=%d\n", pAd->StaCfg.bTGnWifiTest));
						}
--
