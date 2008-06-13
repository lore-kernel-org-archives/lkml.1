Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYFMRhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYFMRhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 13:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYFMRhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 13:37:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:24842 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYFMRhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 13:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=organization:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id:from;
        b=BO0yUUjH7CZERHf6fjTQ+apa3dc+pzoixk6niLdHCOd62IqJ3gkkQPC8cdJOGwQmqZ
         OY3vb0yKAHQ6+EvYuVr6RcCAxlNl6jLWbbsUeaZUvGeI0mxogUdEZom6rGsFnjYKSTry
         aU6iKW/JpiO5AoGIBa0/DkoWLiSKrpAXJsfns=
Organization: M1K0
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Fri, 13 Jun 2008 19:37:03 +0200
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
Message-Id: <200806131937.03680.Michal.Kudla@gmail.com>
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

laptok ~ # modprobe -rv iwl4965
laptok ~ # modprobe -v iwl4965 debug=0x20002
laptok ~ # dmesg >dmesg-`uname -r`_`date +%F`.txt
laptok iwlwifi # ls -1
dmesg-2.6.23-gentoo-r2_2008-06-13.txt
dmesg-2.6.24.7_2008-06-13.txt
dmesg-2.6.25-gentoo-r4_2008-06-13.txt
dmesg-2.6.26-rc5_2008-06-13.txt

results:
http://michal.kudla.googlepages.com/dmesg-debug0x20002.tar.gz

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


