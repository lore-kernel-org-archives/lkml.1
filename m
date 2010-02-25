Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0BYJSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 04:18:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35040 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0BYJSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 04:18:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Q735KGTASVKRHrTiwDgWkWLZY5fcjg/gkCDoJ8FhP+Qzs7jkHmeEYI6gOcTRbQaSKB
         ZXjn0/qQGpzX5O8r0Prpb8FPpBFx1uGPdBo5K8hdMah75NECmU3gCIfg+V7Cxe3YTven
         HLZcFczxpKHfeq+jO8eqzQlHv3bVsYTSJgVAA=
Date: Thu, 25 Feb 2010 12:18:06 +0300
From: Dan Carpenter <error27@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: bug list: other potential buffer overflows
Message-ID: <20100225091805.GC4912@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kernel Janitors,

These are mostly bugs.  Fixing them will gain you eternal glory and honour.

It's from some recent patches to smatch that I'll hopefully push later today.

regars,
dan carpenter

drivers/gpu/drm/drm_edid.c +1032 add_detailed_modes(35) warn: buffer overflow 'data->data.timings' 5 <= 5
drivers/infiniband/core/user_mad.c +655 ib_umad_reg_agent(46) error: buffer overflow 'umm' 4 <= 6
drivers/infiniband/core/user_mad.c +655 ib_umad_reg_agent(46) error: buffer overflow 'umm' 4 <= 7
drivers/media/common/tuners/qt1010.c +387 qt1010_init(67) error: buffer overflow 'i2c_data' 34 <= 34
drivers/net/s2io.c +5811 s2io_vpd_read(47) error: buffer overflow 'vpd_data' 256 <= 256
drivers/net/s2io.c +5812 s2io_vpd_read(48) error: buffer overflow 'vpd_data' 256 <= 257
drivers/net/s2io.c +5814 s2io_vpd_read(50) error: buffer overflow 'vpd_data' 256 <= 257
drivers/net/s2io.c +5814 s2io_vpd_read(50) warn: buffer overflow 'vpd_data' 256 <= 258
drivers/net/wan/lmc/lmc_main.c +1916 lmc_softreset(76) warn: buffer overflow 'sc->lmc_txring' 32 <= 32
drivers/net/wireless/iwlwifi/iwl3945-base.c +1930 iwl3945_init_hw_rates(6) error: buffer overflow 'iwl3945_rates' 12 <= 12
drivers/net/wireless/iwlwifi/iwl3945-base.c +1938 iwl3945_init_hw_rates(14) error: buffer overflow 'iwl3945_rates' 12 <= 12
drivers/net/wireless/iwlwifi/iwl-3945.c +188 iwl3945_hwrate_to_plcp_idx(5) error: buffer overflow 'iwl3945_rates' 12 <= 12
drivers/staging/arlan/arlan-proc.c +471 arlan_sysctl_info(66) warn: buffer overflow 'priva->card->_3' 13 <= 13
drivers/staging/comedi/drivers/cb_pcidda.c +311 cb_pcidda_attach(31) error: buffer overflow 'cb_pcidda_boards' 6 <= 9
drivers/staging/otus/hal/hpani.c +102 zfHpAniAttach(29) error: buffer overflow 'HpPriv->ani' 50 <= 59
drivers/staging/rt2860/common/cmm_wpa.c +414 RTMPToWirelessSta(54) error: buffer overflow 'pAd->TxSwQueue' 4 <= 4
