Return-Path: <linux-kernel-owner+w=401wt.eu-S1945902AbXBUXAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945902AbXBUXAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945903AbXBUXAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:00:31 -0500
Received: from max.feld.cvut.cz ([147.32.192.36]:60491 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945902AbXBUXAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:00:30 -0500
From: CIJOML <cijoml@volny.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Phis in /proc/bus/input/devices same for all devices?
Date: Thu, 22 Feb 2007 00:00:21 +0100
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
References: <200702212313.30359.cijoml@volny.cz> <d120d5000702211448s7d3569cdl1fdcb71d13c3c3ff@mail.gmail.com> <1172098430.7403.54.camel@violet>
In-Reply-To: <1172098430.7403.54.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702220000.21965.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel how can you differ what is src and what is dst, when device can connect 
first time from hub to keyboard and later keyboard to hub?

Michal

Dne støeda 21 únor 2007 23:53 Marcel Holtmann napsal(a):
> Hi Dmitry,
>
> > > > > can anybody reply to this and share his/her opinion?
> > > >
> > > > Input core already exports uniq to udev and also via sysfs.
> > >
> > > so do you think it would be better to create phys as a string of the
> > > source and destination address like "<src>-<dst>" for Bluetooth. And
> > > then keep the uniq empty like all USB devices without serial number do?
> >
> > I'd keep uniq as is and do what you proposed with phys. This way you
> > can either use uniq to identify your device while moving it from one
> > receiver to another (if you have several) or do exact match on phys to
> > get receiver/device pair.
> >
> > Does this make sense?
>
> actually it doesn't help to keep uniq around since the Bluetooth HID
> always reconnects to the same source/host address. Making it reconnect
> results in a virtual cable unplug. So I think that I am going to modify
> the phys to include source and destination address. In the end it is
> only a string.
>
> Regards
>
> Marcel
