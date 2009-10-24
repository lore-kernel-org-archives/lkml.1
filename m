Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbZJXNvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbZJXNvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 09:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZJXNvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 09:51:24 -0400
Received: from web53903.mail.re2.yahoo.com ([206.190.36.126]:23170 "HELO
	web53903.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753700AbZJXNvX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 09:51:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Xsvyn6VS5WDeNwOt+eIMFkD2e6GUX2hGyvVrEG4je0J644GT1B28fKdwfOtoB6HLpFVhillgn15SiirzIUrCTyXdg5pF++y7o97TU1wNetDAliwjaaGf0PYkTJJDLHdN0mdJDcpMnxG2Z+Gh8q334cuJeF/uwakQaOmv9udrKHI=;
Message-ID: <177253.23325.qm@web53903.mail.re2.yahoo.com>
X-YMail-OSG: G3tQiSUVM1mcpdNqtiapI5qrX8BP7NpvcxlZkF6OQLeirNtdDzfF1yd6y6eT5iOBWUzW1TweKAGv26lRpeEGvsZk3F2WPPAfFOpGXr5ujf0V_yb_GzoWMi8g5p_FxdXeIbDwqOzr2vOXwzL2bPw7ACMq2sw3NSnaQwxQES4nTtNmYn2IixRfrl54FovSDVPgndW.Ak0wBDZQLy1hM5SztVGuhcer3e6mnI0gUQ0yvDp7OPphfx6uoLrAYW_1wpcsDxEMsCdtbchkwGHbwWq1qekLXZQIypyfi.lhSBgwmQU5rbU7YUyIVzpyA1Y5XSl.fBJSw31mTgvGLZ.5mCGFvesBzgvtWm9VSKdn.JqzlkXAF3EzWRTGV1am8ffeEaMgHr0U4HBay54EoLifxqQlViOgw7EsCHIYvKummHy9aDw-
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.3
Date: Sat, 24 Oct 2009 06:44:31 -0700 (PDT)
From: Frederik Nosi <fredin77@yahoo.com>
Subject: iwl3945, after a while stops working with "No space for Tx"
To: Zhu Yi <yi.zhu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Tomas Winkler <tomas.winkler@intel.com>,
       Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
       linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
first sorry if somebody is not the right contact, got the adressess from ./scripts/get_maintainer.pl -f drivers/net/wireless/iwlwifi.
>From some kernel versions now, after some time that im using this card it stops working and on messages i get this errors:

Oct 24 14:38:24 kotys NetworkManager: <info>  Activation (wlan0) Stage 5 of 5 (IP Configure Commit) complete.
[snip pulseaudio's stuppid log spam warning]
Oct 24 14:40:07 kotys kernel: iwl3945 0000:04:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Oct 24 14:40:09 kotys pulseaudio[16469]: sap.c: sendmsg() failed: Invalid argument
Oct 24 14:40:10 kotys kernel: iwl3945 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
Oct 24 14:40:11 kotys kernel: iwl3945 0000:04:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Oct 24 14:40:11 kotys kernel: iwl3945 0000:04:00.0: Error sending POWER_TABLE_CMD: time out after 500ms.
Oct 24 14:40:14 kotys kernel: iwl3945 0000:04:00.0: set power fail, ret = -110
Oct 24 14:40:14 kotys kernel: No probe response from AP 00:1c:df:82:63:c9 after 500ms, disconnecting.
Oct 24 14:40:14 kotys NetworkManager: <info>  (wlan0): supplicant connection state:  completed -> disconnected
Oct 24 14:40:14 kotys NetworkManager: <info>  (wlan0): supplicant connection state:  disconnected -> scanning
Oct 24 14:40:14 kotys pulseaudio[16469]: sap.c: sendmsg() failed: Invalid argument
Oct 24 14:40:14 kotys kernel: iwl3945 0000:04:00.0: Error sending REPLY_RXON: time out after 500ms.
Oct 24 14:40:14 kotys kernel: iwl3945 0000:04:00.0: Error setting new configuration (-110).
Oct 24 14:40:15 kotys kernel: iwl3945 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
Oct 24 14:40:15 kotys kernel: wlan0: direct probe to AP 00:1c:df:82:63:c9 (try 1)
Oct 24 14:40:15 kotys NetworkManager: <info>  (wlan0): supplicant connection state:  scanning -> associating
Oct 24 14:40:15 kotys kernel: wlan0: direct probe to AP 00:1c:df:82:63:c9 (try 2)
Oct 24 14:40:15 kotys kernel: wlan0: direct probe to AP 00:1c:df:82:63:c9 (try 3)
Oct 24 14:40:15 kotys kernel: iwl3945 0000:04:00.0: Error sending REPLY_RXON: time out after 500ms.
Oct 24 14:40:15 kotys kernel: iwl3945 0000:04:00.0: Error setting new configuration (-110).
Oct 24 14:40:15 kotys kernel: wlan0: direct probe to AP 00:1c:df:82:63:c9 timed out
Oct 24 14:40:16 kotys kernel: iwl3945 0000:04:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
Oct 24 14:40:16 kotys kernel: iwl3945 0000:04:00.0: Error sending REPLY_RXON: time out after 500ms.
Oct 24 14:40:16 kotys kernel: iwl3945 0000:04:00.0: Error setting new configuration (-110).


When this happens i am able to use the card only after reloading the related modules, iwl3945 ecc. But the problem happens again after some minutes that im connected.

Kernel is 2.6.32-rc5 but his started happening around 2.6.31, not sure exactly what version as i update kernel often. Firmware is iwl3945-ucode-15.32.2.9.

Every other info that you need just ask. I hope i dont have to bisect as this is the laptop i use for work too, but if it's needed i'll do.

I'm not subscribed on any ML, so in case please cc me.

Thanks for all the work!

F.



      
