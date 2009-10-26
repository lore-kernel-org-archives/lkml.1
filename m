Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZJZREx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZJZREx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZJZREw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:04:52 -0400
Received: from web53901.mail.re2.yahoo.com ([206.190.36.211]:36427 "HELO
	web53901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752486AbZJZREv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:04:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=hTwHdUyepUtAPhYegquhEYnsTOs/JttUD9M/uWAEVFqD9bKJS72kBSYy/I9Cxoiijqe2lppMhOgsBxRA5dChxbG+r2hLkKmygBZd2JXmUSJzjHXALEusK/O82Rotl6UwBgN4zO0Yrg77GyzhhMiqlx39iBNESWHMabLBFbPOFdw=;
Message-ID: <776769.29896.qm@web53901.mail.re2.yahoo.com>
X-YMail-OSG: jA.s2_IVM1khxaYsRCiQtHRyNJYUxnjRVerVc336XXn_pjv89t3pewj4WEH88aG1jG7osSBCO6bj42sbE9frvw9ZpOPzNBQUHp0vDGjU47OQvLCQqNroSB6NBO6dm9fJ585fNDXhp6.7k5wCFeHAbA3Vi6iqpm.fucQPqgKZoncv453kfPyg2SAbjAsKz0fPcpzTTA0qtzgD3c5H12FKSxwNIv22SgtSA3s9Rjy.BcjveprYFLJZjry7mArq7u30dE0IoWBfMHDgf8N2.A01oKMGLJ.1ifMZK5Tz0aZ3p_ep3X0kavbXqEWY2iB3FvovHtZATYnzlzD2fWIgBdDwTqu7yjAHP1IBZiJOXw1uoRYLGM4hz6xEDvm7dmJ1Tp3YqwNtIqs.MLbzezoAqvw.OsMfAWFZO3WveYydvnla
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.3
Date: Mon, 26 Oct 2009 10:04:55 -0700 (PDT)
From: Fredi <fredin77@yahoo.com>
Subject: Re: iwl3945, after a while stops working with "No space for Tx"
To: reinette chatre <reinette.chatre@intel.com>
Cc: YiZhu <yi.zhu@intel.com>, Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       TomasWinkler <tomas.winkler@intel.com>,
       AbhijeetKolekar <abhijeet.kolekar@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1256574352.21134.7591.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
first thanks for your reply,
--- On Mon, 26/10/09, reinette chatre <reinette.chatre@intel.com> wrote:

> From: reinette chatre <reinette.chatre@intel.com>
> Subject: Re: iwl3945, after a while stops working with "No space for Tx"
> To: "Frederik Nosi" <fredin77@yahoo.com>
> Cc: "Zhu, Yi" <yi.zhu@intel.com>, "Intel Linux Wireless" <ilw@linux.intel.com>, "John W. Linville" <linville@tuxdriver.com>, "Winkler, Tomas" <tomas.winkler@intel.com>, "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Monday, 26 October, 2009, 5:25 PM
> On Sat, 2009-10-24 at 06:44 -0700,
> Frederik Nosi wrote:
> > Hi,
> > first sorry if somebody is not the right contact, got
> the adressess from ./scripts/get_maintainer.pl -f
> drivers/net/wireless/iwlwifi.
> > From some kernel versions now, after some time that im
> using this card it stops working and on messages i get this
> errors:
> > 
> > Oct 24 14:38:24 kotys NetworkManager:
> <info>  Activation (wlan0) Stage 5 of 5 (IP
> Configure Commit) complete.
> > [snip pulseaudio's stuppid log spam warning]
> > Oct 24 14:40:07 kotys kernel: iwl3945 0000:04:00.0:
> Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
> > Oct 24 14:40:09 kotys pulseaudio[16469]: sap.c:
> sendmsg() failed: Invalid argument
> > Oct 24 14:40:10 kotys kernel: iwl3945 0000:04:00.0:
> Error sending REPLY_SCAN_CMD: time out after 500ms.
> > Oct 24 14:40:11 kotys kernel: iwl3945 0000:04:00.0:
> Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
> > Oct 24 14:40:11 kotys kernel: iwl3945 0000:04:00.0:
> Error sending POWER_TABLE_CMD: time out after 500ms.
> > Oct 24 14:40:14 kotys kernel: iwl3945 0000:04:00.0:
> set power fail, ret = -110
> > Oct 24 14:40:14 kotys kernel: No probe response from
> AP 00:1c:df:82:63:c9 after 500ms, disconnecting.
> > Oct 24 14:40:14 kotys NetworkManager:
> <info>  (wlan0): supplicant connection
> state:  completed -> disconnected
> > Oct 24 14:40:14 kotys NetworkManager:
> <info>  (wlan0): supplicant connection
> state:  disconnected -> scanning
> > Oct 24 14:40:14 kotys pulseaudio[16469]: sap.c:
> sendmsg() failed: Invalid argument
> > Oct 24 14:40:14 kotys kernel: iwl3945 0000:04:00.0:
> Error sending REPLY_RXON: time out after 500ms.
> > Oct 24 14:40:14 kotys kernel: iwl3945 0000:04:00.0:
> Error setting new configuration (-110).
> > Oct 24 14:40:15 kotys kernel: iwl3945 0000:04:00.0:
> Error sending REPLY_SCAN_CMD: time out after 500ms.
> > Oct 24 14:40:15 kotys kernel: wlan0: direct probe to
> AP 00:1c:df:82:63:c9 (try 1)
> > Oct 24 14:40:15 kotys NetworkManager:
> <info>  (wlan0): supplicant connection
> state:  scanning -> associating
> > Oct 24 14:40:15 kotys kernel: wlan0: direct probe to
> AP 00:1c:df:82:63:c9 (try 2)
> > Oct 24 14:40:15 kotys kernel: wlan0: direct probe to
> AP 00:1c:df:82:63:c9 (try 3)
> > Oct 24 14:40:15 kotys kernel: iwl3945 0000:04:00.0:
> Error sending REPLY_RXON: time out after 500ms.
> > Oct 24 14:40:15 kotys kernel: iwl3945 0000:04:00.0:
> Error setting new configuration (-110).
> > Oct 24 14:40:15 kotys kernel: wlan0: direct probe to
> AP 00:1c:df:82:63:c9 timed out
> > Oct 24 14:40:16 kotys kernel: iwl3945 0000:04:00.0:
> Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
> > Oct 24 14:40:16 kotys kernel: iwl3945 0000:04:00.0:
> Error sending REPLY_RXON: time out after 500ms.
> > Oct 24 14:40:16 kotys kernel: iwl3945 0000:04:00.0:
> Error setting new configuration (-110).
> > 
> > 
> > When this happens i am able to use the card only after
> reloading the related modules, iwl3945 ecc. But the problem
> happens again after some minutes that im connected.
> > 
> > Kernel is 2.6.32-rc5 but his started happening around
> 2.6.31, not sure exactly what version as i update kernel
> often. Firmware is iwl3945-ucode-15.32.2.9.
> > 
> > Every other info that you need just ask. I hope i dont
> have to bisect as this is the laptop i use for work too, but
> if it's needed i'll do.
> > 
> > I'm not subscribed on any ML, so in case please cc
> me.
> > 
> 
> We currently have a bug open for this issue. Could you
> please add this
>
> information to
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1944
> ?

Done, noticed that there's a patch for this issue. Will try and tell the results. And noticed the link on how to report possible firmware problems, will follow that procedure and post the results of that too.
 
> Thank you

Thaks for pointing me on the right direction!

> Reinette
> 
> 

Frederik


      
