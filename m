Return-Path: <linux-kernel-owner+w=401wt.eu-S1031679AbXEAMFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031679AbXEAMFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031680AbXEAMFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:05:47 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:27573 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031679AbXEAMFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k0ErgWV6/WPwaj2OggtZ02PBp5stHtzPgVefmXbVj4HkiLhQ6VeZlfYFKPrtB53pdUffUK0vKIsR2XsKU2rRmAE3DZUwbXtdAWCOh39EFuVKlKNPcCtAz/JZlM9G6d2Ps22T7yM85Y8btqey2YTiAGasiNvFX95JMo8RLC01w74=
Message-ID: <d120d5000705010505n6c74cc96l83e55b87a758289@mail.gmail.com>
Date: Tue, 1 May 2007 08:05:44 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: 2.6.22 -mm merge plans (RE: input)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4636F6F7.9090203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <200704302230.50507.dtor@insightbb.com> <4636F6F7.9090203@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> Dmitry Torokhov napsal(a):
> > On Monday 30 April 2007 19:20, Andrew Morton wrote:
> >>  input-ff-add-ff_raw-effect.patch
> >>  input-phantom-add-a-new-driver.patch
> >>
> >
> > It looks like Phanotom will not be using input layer...
>
> Yes, I have a new version, planning to test it tomorrow when I reach the device
> and then post it.
>
> You don't want it in input/misc in that case, right?

Correct. Input/misc is only visible if CONFIG_INPUT is selected. But
if Phantom is not using input layer it should not depend on
CONFIG_INPUT. I'd put it into drivers/misc...

-- 
Dmitry
