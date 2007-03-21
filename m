Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbXCUW4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbXCUW4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbXCUW4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:56:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60330 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbXCUW4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:56:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Suspend to disk bug 2.6.21-rc2-git1
Date: Wed, 21 Mar 2007 23:59:41 +0100
User-Agent: KMail/1.9.5
Cc: Lukas Hejtmanek <xhejtman@mail.muni.cz>, linux-kernel@vger.kernel.org
References: <20070305132331.GF3693@mail.muni.cz> <20070321213007.GA3637@mail.muni.cz> <20070321223908.GI6057@elf.ucw.cz>
In-Reply-To: <20070321223908.GI6057@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703212359.41523.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 21 March 2007 23:39, Pavel Machek wrote:
> Hi!
> 
> > > > I'm not sure what version did exacly caused susped to disk problems but
> > > > anyway, in 2.6.21-rc2-git1, suspend to disk breaks ACPI. ACPI events do not
> > > > even emit ACPI interrupts. Suspend to ram works nicely.
> > > 
> > > Is 2.6.21-latest better?  There were many problems in suspend area,
> > > hopefully they are slowly being fixed...
> > 
> > I've found out that only platform method is working. reboot method does not.
> 
> Try this one.

Good idea.

BTW, we didn't use "platform" during the resume in 2.6.20, so I think this
patch should go into 2.6.21.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
