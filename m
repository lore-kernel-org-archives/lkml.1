Return-Path: <linux-kernel-owner+w=401wt.eu-S932370AbXC0PqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbXC0PqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 11:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932282AbXC0PqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 11:46:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:30303 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370AbXC0PqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 11:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E55THC+2drMJkCwI+9m1NGS5sl20qW95E0RF38W5Vw5KC11mwLA3xlr/T4eY0wOjGJWOEZLkW92cYI64+pZg7Cy96rOkAgoX+8rTHWyI4wTGB7+HYCy4+SsW5eYqXr4DXFyTel8Q8Qjt6gDTEraAttOyUQVUIIbEu9C8F7BFdVk=
Message-ID: <d120d5000703270846y87e4283m4009ff0a9f65dac4@mail.gmail.com>
Date: Tue, 27 Mar 2007 11:46:04 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: Fix sudden warps in mousedev
Cc: "Pete Zaitcev" <zaitcev@redhat.com>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Peter Osterlund" <petero2@telia.com>
In-Reply-To: <460934D7.9030700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070324001610.724a820a.zaitcev@redhat.com>
	 <d120d5000703261230h1724e453je2c14769fc099ad3@mail.gmail.com>
	 <20070326144206.93805eeb.zaitcev@redhat.com>
	 <200703262114.45287.dtor@insightbb.com> <460934D7.9030700@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> Dmitry Torokhov wrote:
> >
> > The driver grabs tochpad with EVIOCGRAB ioctl to prevent input events
> > from bveing delivered to X through /dev/input/mice which is still in
> > whidespread use. That's why evtest does not work. We could as Peter
> > (CCed) to implement an option to turn off grabbing so users who don't
> > use mousedev multiplexor can use evtest and other commands.
> >
>
> What should people be using instead of /dev/input/mice ?

/dev/input/mice is most convenient source untill X gets hotplug ability.

>
> And why did the mouse numbers all get rearranged in 2.6.20, e.g.
> mouse1 became mouse2 for many people?

Input devices are not guaranteed to be stable.

-- 
Dmitry
