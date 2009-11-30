Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZK3Jfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZK3Jfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZK3Jfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:35:42 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:53970 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZK3Jfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:35:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pmApTSlj1UHgYMMktylO/fVrUqzbYQuwVAiHGltx727aFeX+gdQaCmXlbenyPtJT1N
         8cYomphfqUMJs3wEwhJJm/vNlT1IdsCNIuc2vkBNJkyjgIgYQNS85pU6nb6htDOCY3OB
         2zg5Mx8/s5c913zbLScUxugVj0feNrwmc/zSs=
Date: Mon, 30 Nov 2009 01:35:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anisse Astier <anisse@astier.eu>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: i8042 - add Dell Vostro 1520 and 1720 to the
	reset list
Message-ID: <20091130093544.GH10295@core.coreip.homeip.net>
References: <20091124151250.03e185d1@destiny.ordissimo> <20091126110500.735461ac@destiny.ordissimo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126110500.735461ac@destiny.ordissimo>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 11:05:00AM +0100, Anisse Astier wrote:
> Hi Dmitry,
> 
> Sorry for the badly threaded reply, I wasn't subscribed to the list and
> didn't ask explicitely to be Cc-ed.
> 
> >On Wed, 25 Nov 2009 12:17:37 -0800, Dmitry Torokhov wrote:
> >Could youplease explain in more detail what the "bad state" is.
> >And what exactly do you mean by "first boot"? Cold boot? The very
> >first boot after assembling? Something else?
> 
> By bad state I mean that neither touchpad nor keyboard are working. They
> are both unresponsive. You can fix this by adding i8042.reset on the
> kernel command line, or removing the battery and waiting long enough.
> By very first boot I mean when the laptops are received from Dell and
> booted in Linux.
> 
> If you cold boot with a working non-Dell power supply (with same
> electrical characteristics), you can reproduce the "first boot" bug as
> much as you want, and laptops won't work unless you remove the battery
> and wait long enough OR add i8042.reset on the cmdline.
> 

Ok, I see... what about 1320? I did a quick round of googling and it
seem to have the similar issue...

-- 
Dmitry
