Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbYF0SFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbYF0SFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760368AbYF0SBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:01:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:5878 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762031AbYF0SBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=organization:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id:from;
        b=o27s8cgHv1VTbNbDgxfInYgIOrTXDkxC4rpfMOIY7dnhcKFfQaGx6gc9KHaEnIy0WS
         PwLS5v51ZEuvWgeLiGtVGPoGJshc8/IXQFXi4YlDMFOYFPzXIn2BMhPJFmYxmjgwGbux
         hxR56FPPq5ZqZd44vnancXeozUpL0ISRHLlC8=
Organization: M1K0
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Fri, 27 Jun 2008 20:01:26 +0200
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
Message-Id: <200806272001.27516.Michal.Kudla@gmail.com>
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
my WiFi still don't wokrk
Now, I have new kernel 2.6.26-rc8.

Should I patch again this kernel?
Is good patch for rc7 for rc8?


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


