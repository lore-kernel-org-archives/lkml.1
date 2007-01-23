Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbXAWHLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbXAWHLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 02:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932839AbXAWHLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 02:11:14 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:4672 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbXAWHLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 02:11:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OPEDJ11QOcDPb6Cz1kAi2dsLPKDJfEZPIVzMmwzTXgOjNYHwmn5bWGr0JM+qHckTvEBbnCpWYxHtR4GRBv7wb6kWdw/N9hNaLst2wesvIT4HXrDguLSrqeq8FgO578gwMn1VZUFqz631TWi7s3VWgR5JaiipV1SXK1AuosYaIBE=
Message-ID: <3877989d0701222311u5660a3c1id06bbeea3578a1c3@mail.gmail.com>
Date: Tue, 23 Jan 2007 15:11:12 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Jean-Marc Valin" <jean-marc.valin@usherbrooke.ca>
Subject: Re: Suspend to RAM generates oops and general protection fault
Cc: "Pavel Machek" <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <45B59239.90403@usherbrooke.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45B422D3.9040409@usherbrooke.ca>
	 <1169436221.2190.13.camel@nigel.suspend2.net>
	 <45B448BA.70800@usherbrooke.ca> <20070122132545.GA4493@ucw.cz>
	 <45B59239.90403@usherbrooke.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

what about removing psmouse module?

On 1/23/07, Jean-Marc Valin <jean-marc.valin@usherbrooke.ca> wrote:
> >>> will be a device driver. Common causes of suspend/resume problems from
> >>> the list you give below are acpi modules, bluetooth and usb. I'd also be
> >>> consider pcmcia, drm and fuse possibilities. But again, go for unloading
> >>> everything possible in the first instance.
> >> Actually, the reason I sent this is that when I showed the oops/gpf to
> >> Matthew Garrett at linux.conf.au, he said it looked like a CPU hotplug
> >> problem and suggested I send it to lkml. BTW, with 2.6.20-rc5, the
> >> suspend to RAM now works ~95% of the time.
> >
> > Try a kernel without CONFIG_SMP... that will verify if it is SMP
> > related.
>
> Well, this happens to be my main work machine, which I'm not willing to
> have running at half speed for several weeks. Anything else you can suggest?
>
>         Jean-Marc
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
