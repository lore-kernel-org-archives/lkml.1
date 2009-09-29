Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZI2M0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZI2M0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZI2M0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:26:50 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:60306 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZI2M0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:26:49 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH] USB: digi_acceleport: Fix broken unthrottle.
Date: Tue, 29 Sep 2009 14:28:33 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Peter Berger <pberger@brimson.com>,
       Al Borchers <alborchers@steinerpoint.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090929103923.GA2866@localhost> <200909291320.46815.oliver@neukum.org> <20090929113518.GE2152@localhost>
In-Reply-To: <20090929113518.GE2152@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909291428.33937.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 29. September 2009 13:35:18 schrieb Johan Hovold:
> On Tue, Sep 29, 2009 at 01:20:44PM +0200, Oliver Neukum wrote:
> > Am Dienstag, 29. September 2009 12:39:23 schrieb Johan Hovold:
> > > This patch is untested as I haven't got the hardware, but seems
> > > straight-forward to me.
> > >
> > > Can you verify, Oliver?
> >
> > I would prefer to see a check in usb-serial.c::serial_unthrottle()
>
> This is completely unrelated to the unthrottle issue discussed elsewhere.
> :)
>
> The digi_acceleport unthrottle code should (and used to) check
> priv->dp_throttle_restart to determine whether to resubmit and then
> cleared the flag. The commit mentioned mistakenly, I assume, reversed this.
> Plain bug. Right?

Eek. Yes, sorry. Unthrotteling as I currently made it cannot work.
Your fix is completely correct.

	Regards
		Oliver

Acked-by: Oliver Neukum <oliver@neukum.org>

