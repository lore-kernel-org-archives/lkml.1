Return-Path: <linux-kernel-owner+w=401wt.eu-S1764587AbXE2L5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764587AbXE2L5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXE2L5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:57:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36962 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbXE2L5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:57:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
Date: Tue, 29 May 2007 14:03:07 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
References: <4658B7DD.3060309@tmr.com> <1180392482.4149.15.camel@nigel.suspend2.net> <20070529112952.GA23046@elf.ucw.cz>
In-Reply-To: <20070529112952.GA23046@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291403.09773.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 29 May 2007 13:29, Pavel Machek wrote:
> Hi!
> 
> > > Yup.  Don't we do something like this for the (ACPI-based) suspend to RAM
> > > already?
> > 
> > Yeah, I was thinking about this overnight too. It should be doable. In
> > addition to what we already do, I think you'd want:
> > 
> > - to copy the assembly to do the copying to a safe page;
> > - to put the location of the cpu state that was saved in the image
> > header so that it can be used after the data is copied back;
> 
> ...alternatively, we can just rely on copy routine (and its data) not
> changing frequently.
> 
> > - to copy the nosave data to a 'safe' page.
> > 
> > What else?
> 
> page directories need to be on a safe place, too.

They are already.

Greetings,
Rafael
