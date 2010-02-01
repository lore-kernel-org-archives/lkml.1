Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0BAUOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:14:51 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:64465 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab0BAUOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:14:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dK2+XYJd8DsiU4Cv24K02cECmts3PQ5ZePYgnGN1pG6bS9rBHlTGbrfW0keNTPcSEB
         MLbHw3pxjWWGXfmg2zsdnetAXw/m/PT0xyRG1m7j4PMskf52GdKUW2YpttYmpV70JZPq
         7NT5FHzL/KUHfQ12f89zyUEqk1feZ5Tg4/0W8=
Subject: Re: Linux wireless GSoC 2010 project ideas
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Witold Sowa <witold.sowa@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Till Kamppeter <till.kamppeter@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, lsb-discuss@lists.linux-foundation.org
In-Reply-To: <43e72e891002011001l4e914094v33e73209a9da93e8@mail.gmail.com>
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com>
	 <4B65F024.3080505@gmail.com> <1264972854.3597.17.camel@johannes.local>
	 <43e72e891002011001l4e914094v33e73209a9da93e8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 22:14:44 +0200
Message-ID: <1265055284.26421.16.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 10:01 -0800, Luis R. Rodriguez wrote: 
> On Sun, Jan 31, 2010 at 1:20 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2010-01-31 at 22:03 +0100, Witold Sowa wrote:
> >
> >> Some time ago johill asked me if I would be interested in hacking on
> >> adding WPS support to NetworkManager. Well, I would but I don't know
> >> when I'll find some time for that. I don't know how much of work would
> >> it require, but it possibly could be a topic of one of GSoC 2010
> >> projects. I have no idea know if anybody would be willing to be a mentor
> >> for such a project.
> >
> > Sounds like a good project to me, but I don't think I'd be a good mentor
> > for since I'm not familiar with the NM codebase at all. As for how much
> > work it would require, I think the basic client-side functionality could
> > possibly be "too simple" for you, WPS has a lot of additional
> > functionality (e.g. WPS support for the AP side).
> 
> In case it helps, I believe all that would be required is the dbus
> stuff, there are sample GUI examples of this already provided through
> the wpa_supplicant wpa_gui.

Here are couple of ideas (I don't think I will enter the program
though):

1 - Make Ad-Hoc WPA networks work (with NM). This would involve changes
in kernel, but I don't think will involve changes in hardware drivers.

2 - Allow a wireless card to associate to several APs at once (if they
share the frequency). 
Implement this at least for ath5/9k. Madwifi had that feature. Maybe
ath9k has. If it has that feature, test it.
Implement proper GUI support in NM for that.

3 - Create wardriving^Wwireless analysis tool.
No, not for wardriving. I mean an application that shows and analyzes
nicely the signal strength of nearby APs, and other features of it 

airodump-ng does have some features, but it is focused too much on
cracking that on analysis.
For example it slows to an crawl, when I attempt to do iperf and monitor
huge traffic that is sent.

It could see how many packets are dropped, how many resends were done,
have proper ESSID filter, so it can be used in large scale networks
(I once tried to understand locations of wifi access points in my uni,
so I know where to get proper wifi connection.)

A lot more can be extracted from monitor mode.


Best regards,
Maxim Levitsky

