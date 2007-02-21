Return-Path: <linux-kernel-owner+w=401wt.eu-S1751247AbXBUMs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbXBUMs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 07:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXBUMs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 07:48:58 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:44189 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751247AbXBUMs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 07:48:58 -0500
Message-ID: <45DC3F03.3070909@aitel.hist.no>
Date: Wed, 21 Feb 2007 13:45:55 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@aitel.hist.no>, v j <vj.linux@gmail.com>,
       davids@webmaster.com, trent.waddington@gmail.com,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com> <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com> <9b3a62ab0702192119l1bf9a284la93c9d1f01638ca4@mail.gmail.com> <45DB0788.1000600@aitel.hist.no> <20070220203023.GB9712@lug-owl.de>
In-Reply-To: <20070220203023.GB9712@lug-owl.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Benedict Glaw wrote:
> On Tue, 2007-02-20 15:36:56 +0100, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
>   
>> If you have a need for "secret" source code, stuff most of it
>> in userspace.  Make the drivers truly minimal; perhaps their
>> open/closed status won't matter that much when the bulk
>> of the code and the cleverness is kept safe in userspace.
>>
>> Note that keeping drivers small this way is the recommended
>> way of working anyway. It isn't merely a way to keep your
>> code away from the GPL - you always want a small kernel.
>>     
>
> Keeping the legal stuff out of sight for a second, this'll solve the
> "problem" for the embedded developer, but surely not for the Linux
> community. Would you ever expect that eg. the thin GPL layer used by
> ATI/NVidia would be merged iff the rest would run in userland?
>   
A thin layer - no.  To get merged, a driver would have to
be of good quality.  I didn't think like that - I was thinking of
embedded developers that sometimes implement the
entire embedded application inside their device driver.

Which is crazy from a linux design standpoint, but sometimes
reasonable for an embedded developer when the sole purpose of
the embedded computer is to control the single "device" and
perhaps a little display with a couple of buttons.
The "app" part might not be that much
bigger than the device driver itself - it is then tempting to
cut some corners and put all in one place.

Of course this kind of "driver" ends up containing everything,
and nobody wants to GPL that.  Separating driver and app(s)
properly lets them keep a proprietary app, and a driver or two
that might be small and simple enough to be released.
> It's just a workaround for the
> linking-the-object-file-into-the-kernel-image problem, but after all,
> it doesn't lead to a working driver being freely available.
>
> MfG, JBG

Good point.  Fortunately, most devices are much simpler than
a card with accelerated 3D-graphichs.

Helge Hafting




