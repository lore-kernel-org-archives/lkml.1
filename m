Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380Ab0ABCxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab0ABCxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 21:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304Ab0ABCxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 21:53:18 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33603 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab0ABCxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 21:53:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NoZnoEks9rPSxpfBLTPJgVewHR/irmyHxtafQlWrGHx2JbPOHpVPloFUev+kDtr9ku
         0c3S4slpxA2rB7GHBF7+Cwr+LE9Z+I/2qXwB0khxhZHY1AWt8MuRQ//WMA/OQy0+doL+
         Gk9AcOepKtUau8I+OQTTpn+mTR+YDA/zhBDZM=
Date: Fri, 1 Jan 2010 18:53:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wayne Thomas <waynethomas69@gmail.com>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: driver for BTC "Emprex 3009URF III Vista MCE
 Remote" quirky remote
Message-ID: <20100102025312.GC5788@core.coreip.homeip.net>
References: <3711715e0912310013u25e921cbqe6abb7c1621109e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3711715e0912310013u25e921cbqe6abb7c1621109e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wayne,

On Thu, Dec 31, 2009 at 09:13:22AM +0100, Wayne Thomas wrote:
> HID: driver for BTC "Emprex 3009URF III Vista MCE Remote" quirky remote
> 
> The Behavior Tech. Computer Corp. (BTC) remote branded as "Emprex 3009URF III
> Vista Remote Controller" uses non-standard mappings for all of its 'special
> purpose' keys (0xffbc usage page).  Applies cleanly to 2.6.30 and 2.6.32
> (other versions not tested).
> scripts/scriptpatch.pl reports 13 styling errors in hid-btc.c
> ("break;" should be on trailing lines)
> but have not changed them to maintain styling consistency with existing drivers.
> 

I believe that this kind of mapping adjustment can be done via UDEV/HAL
key remapping facilities, without need for the kernel patch.

Thanks.

-- 
Dmitry
