Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbYGFUpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbYGFUpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbYGFUpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:45:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:45783 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257AbYGFUo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=organization:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id:from;
        b=kcXlumPrx8VOzipv6PzWjpCNIQhHgGKN5xmRM7mqFPhKLMZHxV30+OljnQJZRrYBIk
         gzEvTiLXY9Jkad/GqE+ye+UBcXCFBHJ9jT/bMQ3b7hqQctkxlmAkCnRiOYt65buDn/dl
         KL9/KrlLGOvvBbyN0MQ9Sv0Umpxnhnyz2Juy0=
Organization: M1K0
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Sun, 6 Jul 2008 22:44:53 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
References: <200806060039.48488.m1k0@wp.pl> <200806240537.08888.Michal.Kudla@gmail.com> <1214279513.14590.198.camel@debian.sh.intel.com>
In-Reply-To: <1214279513.14590.198.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807062244.53787.Michal.Kudla@gmail.com>
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
with new build -rc9 iwl4965 still don't work.
I don't know, witch distro I should use to check, that current kernel and my 
WiFi is OK.

I returned to good 2.6.24-gentoo-r8


W liście datowanym na wtorek, 24 czerwca 2008, Zhu Yi pisze:
>ZY On Tue, 2008-06-24 at 05:37 +0200, Michał Kudła wrote:
>ZY > laptok ~ # cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill
>ZY > \:rfkill1/state
>ZY > 0
>ZY > laptok ~ # echo "1"> /sys/bus/pci/drivers/iwl4965/0000\:04
>ZY > \:00.0/rfkill\:rfkill1/state
>ZY > laptok ~ # iwconfig wlan0 txpower on
>ZY > laptok ~ # /etc/init.d/net.wlan0 restart
>ZY >  * Service net.wlan0 starting
>ZY >  Failed to configure wireless for wlan0
>ZY > [ !! ] * ERROR:  net.wlan0 failed to start
>ZY
>ZY Looks like the wireless config scripts in your distro did something
>ZY (probably txpower off) to disable the SW radio. Can you try the
>ZY following commands after wlan0 restart?
>ZY
>ZY $ cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill\:rfkill1/state
>ZY $ echo 1 > /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill
>ZY \:rfkill1/state
>ZY $ ifconfig wlan0 up
>ZY
>ZY Thanks,
>ZY -yi
>ZY
>ZY


