Return-Path: <linux-kernel-owner+w=401wt.eu-S1762900AbYFKTR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900AbYFKTR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762420AbYFKTRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:17:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:56624 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762273AbYFKTRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=organization:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id:from;
        b=fuQovPFdxJOGr80sYxA3ypfohdsU/1PaD/qZNoodZsZPsMkl3cEZ3t69/+NhFObUV0
         4B+XW2Q+zEGNMeiJvcKS9vUtim6XJKnUbi8gwtkVnqvB5R8D351P0vukBZ/hZvJ2Gr7/
         2JbPCOZTOAvdfDXumHx1fYTOuvtn95cX/Fm+I=
Organization: M1K0
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Wed, 11 Jun 2008 21:17:00 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
References: <200806060039.48488.m1k0@wp.pl> <20080606034738.9835782d.akpm@linux-foundation.org> <1213151464.7814.630.camel@debian.sh.intel.com>
In-Reply-To: <1213151464.7814.630.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806112117.01544.Michal.Kudla@gmail.com>
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Still don't work.
I have tested this patch with and without RFKILL kernel settings
Compressed result files:
config-2.6.26-rc5-no-rfkill.txt
config-2.6.26-rc5-rfkill.txt
dmesg-2.6.26-rc5-no-rfkill.txt
dmesg-2.6.26-rc5-rfkill.txt
are in
http://michal.kudla.googlepages.com/iwlwifi-problem-with-patch-Zhu-Yi.ta.bz2



W liście datowanym na środa, 11 czerwca 2008, Zhu Yi pisze:
>ZY On Fri, 2008-06-06 at 03:47 -0700, Andrew Morton wrote:
>ZY > > ADDRCONF(NETDEV_UP): wlan0: link is not ready
>ZY > > iwl4965: Error sending REPLY_WEPKEY: enqueue_hcmd failed: -5
>ZY > > mac80211-phy0: failed to remove key (0, ff:ff:ff:ff:ff:ff) from
>ZY > hardware (-5)
>ZY > > iwl4965: Error sending REPLY_TX_PWR_TABLE_CMD: enqueue_hcmd failed:
>ZY > -5
>ZY > > iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
>ZY > > iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
>ZY
>ZY Looks like a rfkill related problem. Can you please try this patch?
>ZY http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1673
>ZY
>ZY Thanks,
>ZY -yi
>ZY
>ZY


