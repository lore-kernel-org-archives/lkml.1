Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212Ab0A0Kk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0A0Kk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061Ab0A0Kk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:40:27 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:54143 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab0A0Kk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:40:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=tEXw4Co3mITXRsGiQIW3jQ5rjO1PkXh+/jabqdAe4vZRFyyn+ORh/kP/8XZjRTe0zs
         HvO4uGLvsHgDprcGH54KVl5fhah1Pb8yDRxakC/EcB89UoLLPfRc4/f942JCGPjoz7yN
         o7EaF/RIPyTWpO4U5H0ibWNbrVOIOYW/S1AGI=
Date: Wed, 27 Jan 2010 13:40:11 +0300
From: Dan Carpenter <error27@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: bug list: assigning negative values to unsigned variables
Message-ID: <20100127104011.GA24796@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing the places which assign negative values to unsigned variables is a good janitor task.

This list is from smatch:  grep -w "fit into 0" warns.txt | grep -v "\-1" | tee err-list

regards,
dan carpenter

drivers/bluetooth/btmrvl_main.c +74 btmrvl_process_event(9) warn: value -22 can't fit into 0 'ret'
drivers/bluetooth/btmrvl_main.c +123 btmrvl_process_event(58) warn: value -22 can't fit into 0 'ret'
drivers/bluetooth/btmrvl_main.c +136 btmrvl_process_event(71) warn: value -22 can't fit into 0 'ret'
drivers/char/mwave/smapi.c +69 smapi_request(12) warn: value -5 can't fit into 0 'usSmapiOK'
drivers/net/ixgbe/ixgbe_dcb_nl.c +439 ixgbe_dcbnl_getcap(29) warn: value -22 can't fit into 0 'rval'
drivers/net/ixgbe/ixgbe_dcb_nl.c +443 ixgbe_dcbnl_getcap(33) warn: value -22 can't fit into 0 'rval'
drivers/net/ixgbe/ixgbe_dcb_nl.c +463 ixgbe_dcbnl_getnumtcs(14) warn: value -22 can't fit into 0 'rval'
drivers/net/ixgbe/ixgbe_dcb_nl.c +467 ixgbe_dcbnl_getnumtcs(18) warn: value -22 can't fit into 0 'rval'
drivers/net/wireless/b43legacy/phy.c +1205 b43legacy_phy_lo_b_measure(60) warn: value -772 can't fit into 0 'fval'
drivers/net/wireless/b43legacy/phy.c +1632 b43legacy_phy_lo_g_measure(143) warn: value -3 can't fit into 0 'tmp'
drivers/net/wireless/hostap/hostap_ioctl.c +1020 prism2_ioctl_giwrange(66) warn: value -60 can't fit into 0 'range->avg_qual.level'
drivers/net/wireless/hostap/hostap_ioctl.c +1021 prism2_ioctl_giwrange(67) warn: value -95 can't fit into 0 'range->avg_qual.noise'
drivers/net/wireless/ipw2x00/ipw2100.c +6901 ipw2100_wx_get_range(37) warn: value -78 can't fit into 0 'range->avg_qual.level'
drivers/net/wireless/libertas/wext.c +875 lbs_get_wireless_stats(34) warn: value -96 can't fit into 0 'priv->wstats.qual.noise'
drivers/net/wireless/prism54/isl_ioctl.c +452 prism54_get_range(33) warn: value -80 can't fit into 0 'range->avg_qual.level'
drivers/net/bnx2x_link.c +3189 bnx2x_sfp_module_detection(21) warn: value -22 can't fit into 0 'rc'
drivers/net/bnx2x_link.c +4548 bnx2x_ext_phy_init(911) warn: value -22 can't fit into 0 'rc'
drivers/net/bnx2x_link.c +4553 bnx2x_ext_phy_init(916) warn: value -22 can't fit into 0 'rc'
drivers/net/bnx2x_link.c +5556 bnx2x_get_ext_phy_fw_version(53) warn: value -22 can't fit into 0 'status'
drivers/net/bnx2x_link.c +5854 bnx2x_set_led(59) warn: value -22 can't fit into 0 'rc'
drivers/staging/rt2860/sta_ioctl.c +564 rt_ioctl_giwrange(60) warn: value -60 can't fit into 0 'range->avg_qual.level'
drivers/staging/rt2860/sta_ioctl.c +565 rt_ioctl_giwrange(61) warn: value -95 can't fit into 0 'range->avg_qual.noise'
drivers/staging/rt2870/../rt2860/sta_ioctl.c +564 rt_ioctl_giwrange(60) warn: value -60 can't fit into 0 'range->avg_qual.level'
drivers/staging/rt2870/../rt2860/sta_ioctl.c +565 rt_ioctl_giwrange(61) warn: value -95 can't fit into 0 'range->avg_qual.noise'
drivers/staging/rtl8187se/r8180_wx.c +275 rtl8180_wx_get_range(39) warn: value -98 can't fit into 0 'range->max_qual.noise'
drivers/staging/rtl8187se/r8180_wx.c +280 rtl8180_wx_get_range(44) warn: value -78 can't fit into 0 'range->avg_qual.level'
drivers/staging/rtl8192e/r8192E_wx.c +445 rtl8180_wx_get_range(39) warn: value -98 can't fit into 0 'range->max_qual.noise'
drivers/staging/rtl8192e/r8192E_wx.c +450 rtl8180_wx_get_range(44) warn: value -78 can't fit into 0 'range->avg_qual.level'
drivers/staging/rtl8192su/r8192U_wx.c +434 rtl8180_wx_get_range(39) warn: value -98 can't fit into 0 'range->max_qual.noise'
drivers/staging/rtl8192su/r8192U_wx.c +439 rtl8180_wx_get_range(44) warn: value -78 can't fit into 0 'range->avg_qual.level'
drivers/staging/rtl8192u/r8192U_wx.c +420 rtl8180_wx_get_range(39) warn: value -98 can't fit into 0 'range->max_qual.noise'
drivers/staging/rtl8192u/r8192U_wx.c +425 rtl8180_wx_get_range(44) warn: value -78 can't fit into 0 'range->avg_qual.level'
drivers/usb/serial/iuu_phoenix.c +565 iuu_clk(125) warn: value -2 can't fit into 0 '*(priv->buf+Count++)'
