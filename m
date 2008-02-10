Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYBJXc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYBJXc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYBJXcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:32:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:44986 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbYBJXcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Jh98wK4GZnJxeQ1D7XmP9t6B0TQvm1pxTTJh3RTOJTfXDaNemv327YZ8YeQ8jKbHNgJaamLpODfmBRQngOhc9rzl/bqbP3jfYBQ4vs3HFyyozBIKbyw8EzbiDBjANNWk48u2KKpVTNQw8ueYWDDZjTmikRNxfIT09CyywDSCxhw=
Message-ID: <76366b180802101532k35a56e89g4c498e30834461f8@mail.gmail.com>
Date: Sun, 10 Feb 2008 18:32:49 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: I/O collisions w/ hwmon/it87.c and watchdog/it8712f_wdt.c? (Super I/O chips in general..)
Cc: linux-kernel@vger.kernel.org, "Jorge Boncompte" <jorge@dti2.net>,
       "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <20080210230538.3f5743f6@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <76366b180802101304j359e2873vd9dd974920bf6745@mail.gmail.com>
	 <20080210230538.3f5743f6@core>
X-Google-Sender-Auth: ad34d2a9d57c6808
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does it make sense to use the drivers/mfd directory for Super I/O
chips then? Is there any problem with having other hwmon, watchdog,
etc depend on drivers/mfd? Should this kind of setup for platform
devices be documented in the driver-model?

-Andrew

On Feb 10, 2008 6:05 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Since these chips touch many different parts of traditionally separate
> > driver areas, how should the drivers be structured so that they can
> > all talk to the chip? Should the low level communications routines for
> > the chip live in a library which all the drivers could use?
>
> Probably yes. And that if possible should manage all the locking. Thats
> roughly how the majority of drivers do it. Some export the lock from base
> code and inline the accessors depending how complex it is.
