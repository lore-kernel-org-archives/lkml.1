Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZLSWGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZLSWGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 17:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZLSWGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 17:06:01 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:33496 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbZLSWGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 17:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=MzLHvtKaXycE3233SEqjvWWFHGtjugCw0NmOy9KNKKiKyHL4+MxL+FwKmu2+F0VO7f
         +1E0tg3xYFqjtIs+11NYKpA0H82fVQg8ydwuI1QT7qwzR6bqwB52lG2QStEP+GBgXJGq
         WgWCO8qWpTShCS3kW0R05XgMfm3QEcVwHg3lM=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Peter Hutterer <peter.hutterer@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
References: <20091203050810.GA26595@barra.bne.redhat.com>
	<87zl60s17o.fsf@macbook.be.48ers.dk> <4B1836A6.405@redhat.com>
	<871vjasxnm.fsf@macbook.be.48ers.dk> <4B190D88.4090102@redhat.com>
	<87ws12rh5j.fsf@macbook.be.48ers.dk> <4B1C96C4.5080709@redhat.com>
	<87hbs0mqju.fsf@macbook.be.48ers.dk> <4B2B0CCE.2020406@redhat.com>
Date: Sat, 19 Dec 2009 23:05:53 +0100
In-Reply-To: <4B2B0CCE.2020406@redhat.com> (Peter Hutterer's message of "Fri,
	18 Dec 2009 15:02:06 +1000")
Message-ID: <87638239ha.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Peter" == Peter Hutterer <peter.hutterer@redhat.com> writes:

Hi,

 >> I see this:  http://peter.korsgaard.com/nw.png

 Peter> argh. now you made me use vista! ;)

Sorry, I promise it won't happen again ;)

 Peter> For reporting mode 4 and 3, the events are Z/Rx + touch
 Peter> For reporting mode 1 and 9, the events are ABS_X/Y and left button
 Peter> For reporting mode 0 and 8, no events are sent (unsurprisingly)

 Peter> So it seems the only difference between our two models is the default
 Peter> reporting mode - assuming that 4 is the default, we've had this thing
 Peter> for a year without doing much with it but it could well be that
 Peter> someone set it earlier or one of the HP Touchsmart software pieces
 Peter> changed it.

Ok, thanks for checking it all out! Just to be completely sure, the
quirk doesn't cause any problems in mode 1/9, right?

 >> I'm willing to work on getting evdev to handle multi screen touchscreen
 >> setups better if needed, I just need a bit of guidance on how it should
 >> be handled.

 Peter> replying to your email right now.

Thanks.

-- 
Bye, Peter Korsgaard
