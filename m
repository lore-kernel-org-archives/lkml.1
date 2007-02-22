Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbXBVPGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbXBVPGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933098AbXBVPGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:06:11 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:32221 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbXBVPGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:06:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Btaf8kYD85uechuxHolWwtyWQ3VOkk7bpxMprqZmbxUXaD/RMGjWHH5LLk5e8wnnljJbMG00SlZPQDR2eRYPK+4xP+DQSqIZ/j9ZrfXDL/w8n2WpG4QaFesqNIHk6WrOGvJ1CQQXrHtNYTvaTz4tOAf0Hzwuek+KNMpMeUjWITA=
Message-ID: <d120d5000702220706m5376d133lac6f7807da055e19@mail.gmail.com>
Date: Thu, 22 Feb 2007 10:06:09 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: Re: Phis in /proc/bus/input/devices same for all devices?
Cc: CIJOML <cijoml@volny.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <1172098430.7403.54.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702212313.30359.cijoml@volny.cz>
	 <d120d5000702211427y423acfdekb83343a4f90caab0@mail.gmail.com>
	 <1172097890.7403.52.camel@violet>
	 <d120d5000702211448s7d3569cdl1fdcb71d13c3c3ff@mail.gmail.com>
	 <1172098430.7403.54.camel@violet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

On 2/21/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dmitry,
>
> > > > > can anybody reply to this and share his/her opinion?
> > > >
> > > > Input core already exports uniq to udev and also via sysfs.
> > >
> > > so do you think it would be better to create phys as a string of the
> > > source and destination address like "<src>-<dst>" for Bluetooth. And
> > > then keep the uniq empty like all USB devices without serial number do?
> > >
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

Matching on uniq (and having uniq available) makes sense when you want
to perform device-specific setup and want it to work even if you
change your BT adapter. Imagne yopu have a keyboard that yoou want to
handle in a special way and after you set up your BT card gets fried
and you buy another one. When matchign on uniq your setup will not
change at all.

-- 
Dmitry
