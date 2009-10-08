Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbZJHSRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbZJHSRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932793AbZJHSRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:17:24 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:64556 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbZJHSRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:17:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s43GPoe0uYziKrFSDJzgtwLZO0Wuk2pisKUHceZhkBWHNWW6keQWJbjNoE3S4Wiu9a
         lq/YuyLTkj2oEatwPCOPOyqPddJ9niru2u48y609E08UO5MqQam4kHBnNLCfTGrzk7gh
         SF8Vb7CqEjdn7pUIWg885+1Y5VvbRsA2w++tw=
Date: Thu, 8 Oct 2009 20:15:34 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       johannes@sipsolutions.net
Subject: Re: [2.6.32-rc3] iwlagn lost connection after s2ram (with warnings)
Message-ID: <20091008181534.GA19621@Pilar.aei.mpg.de>
References: <20091007142031.GA7495@Pilar.aei.mpg.de> <1255023883.26521.13298.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255023883.26521.13298.camel@rc-desk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Reinette,

On Thu  8.Oct'09 at 10:44:43 -0700, reinette chatre wrote:
> Hi Carlos,
> 
> On Wed, 2009-10-07 at 07:20 -0700, Carlos R. Mafra wrote:
> > I just got these warnings after resuming from a suspend to RAM, and
> > the wireless connection was not resumed (now I am connected via eth0).
> > This is the first time I had a failed wireless resume since 2.6.32-rc1.
> > 
> > The full dmesg is here: http://www.aei.mpg.de/~crmafra/dmesg-2.6.32-rc3-wifi.txt
> > 
> > [ 3427.570113] Restarting tasks ... 
> > [ 3427.585827] wlan0: deauthenticated from 00:0b:86:26:36:f1 (Reason: 6)
> > [ 3427.589451] done.
> > [ 3428.503203] input: PS/2 Mouse as /devices/platform/i8042/serio4/input/input15
> > [ 3428.521064] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio4/input/input16
> > [ 3434.504175] wlan0: direct probe to AP 00:0b:86:26:36:f1 (try 1)
> > [ 3434.507058] wlan0: direct probe responded
> > [ 3434.507062] wlan0: authenticate with AP 00:0b:86:26:36:f1 (try 1)
> > [ 3434.509000] wlan0: authenticated
> > [ 3434.509022] wlan0: associate with AP 00:0b:86:26:36:f1 (try 1)
> > [ 3434.512778] wlan0: RX ReassocResp from 00:0b:86:26:36:f1 (capab=0x431 status=0 aid=2)
> > [ 3434.512782] wlan0: associated
> > [ 3434.563942] wlan0: deauthenticating from 00:0b:86:26:36:f1 by local choice (reason=3)
> 
> You mention you are trying to connect again after a resume. The message
> above indicates that userspace (maybe wpa_supplicant ?) requested that
> the connection be closed. Do you maybe know how this could have been
> triggered?

I have two processes that are always running,

/usr/sbin/wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf -D wext
/sbin/ifplugd -I -b -i wlan0

and I guess they are the "userspace" that do automatic things to reconnect.

But I have no idea about what happened, or how it happened. I simply resumed from
s2ram like I always do and got those warnings and no connection.

Today I did the same (with the same kernel), and the connection was resumed just 
fine and I got no warnings in dmesg. So it is not easily reproduced :-(

I will keep you informed if it happens again.
