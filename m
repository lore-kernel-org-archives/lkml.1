Return-Path: <linux-kernel-owner+w=401wt.eu-S1423255AbXBUWxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423255AbXBUWxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423254AbXBUWxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:53:12 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:44066 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423255AbXBUWxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:53:10 -0500
Subject: Re: Re: Phis in /proc/bus/input/devices same for all devices?
From: Marcel Holtmann <marcel@holtmann.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: CIJOML <cijoml@volny.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <d120d5000702211448s7d3569cdl1fdcb71d13c3c3ff@mail.gmail.com>
References: <200702212313.30359.cijoml@volny.cz>
	 <d120d5000702211427y423acfdekb83343a4f90caab0@mail.gmail.com>
	 <1172097890.7403.52.camel@violet>
	 <d120d5000702211448s7d3569cdl1fdcb71d13c3c3ff@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 23:53:50 +0100
Message-Id: <1172098430.7403.54.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> > > > can anybody reply to this and share his/her opinion?
> > >
> > > Input core already exports uniq to udev and also via sysfs.
> >
> > so do you think it would be better to create phys as a string of the
> > source and destination address like "<src>-<dst>" for Bluetooth. And
> > then keep the uniq empty like all USB devices without serial number do?
> >
> 
> I'd keep uniq as is and do what you proposed with phys. This way you
> can either use uniq to identify your device while moving it from one
> receiver to another (if you have several) or do exact match on phys to
> get receiver/device pair.
> 
> Does this make sense?

actually it doesn't help to keep uniq around since the Bluetooth HID
always reconnects to the same source/host address. Making it reconnect
results in a virtual cable unplug. So I think that I am going to modify
the phys to include source and destination address. In the end it is
only a string.

Regards

Marcel


