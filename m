Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZICSf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZICSf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbZICSf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:35:26 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:42279 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbZICSfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=Doo7fLFpn2KThlvGX56+n/a2Hak9U4BnlcmOBpeaEGamJToIGTtCONPNuqgG5ZZglB
         YLx6a5TYRQTsXmbJlcp/lshP7BJgWYVwri2PAcm4s9ElXN4/0WMCVhGHS8BBxUt57WcN
         LXD4X9/tVI2BRF/e2SGfCHkb4RGdapEHCvNgM=
To: Greg KH <greg@kroah.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: Staging tree status for the .32 kernel merge
References: <20090903041429.GA29875@kroah.com>
	<1251967786.3336.19.camel@johannes.local>
	<200909031448.46943.s.L-H@gmx.de> <20090903175723.GC24943@kroah.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 03 Sep 2009 21:35:23 +0300
In-Reply-To: <20090903175723.GC24943@kroah.com> (Greg KH's message of "Thu\, 3 Sep 2009 10\:57\:23 -0700")
Message-ID: <87y6ov98r8.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

>> at76c50x-usb, the mac80211 port of at76_usb, has been merged mainline in 
>> 2.6.30, it works well on two at76c503a devices for me. 
>
> So should I drop at76_usb from the tree right now?  It seems to cover
> the same exact device ids, sorry for not noticing it yet.

Yes, please remove at76_usb from staging. It's not needed anymore now
that at76c50x-usb is in mainline. I know that some people are still
using at76_usb, but they need to convert sooner or later. And better to
force them to do it sooner.

-- 
Kalle Valo
