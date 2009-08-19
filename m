Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZHSWQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZHSWQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 18:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZHSWQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 18:16:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:42313 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbZHSWQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 18:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nEyMx9dirZDbylcKhTejm3k9MKx4vCFh0mZsCakhBLjrOaSMd4gHEYNTeg0c2euQXU
         YAfxTHwC+7guB8gSu3Wd9OZHLVIp2JzrhAXE9oG9rcpxcCUjB/RLm7iGi1f6iNnv6anW
         4kOwrqHwa64NMR6SaV6ZzrKqSBXcy89igZYAE=
MIME-Version: 1.0
In-Reply-To: <20090818211946.GA23309@kroah.com>
References: <589ee1d0908160656u40672d47i7a7abe9923681f09@mail.gmail.com>
	 <20090817044450.GB20884@kroah.com>
	 <589ee1d0908171837u70e14c41hdd6fd4ab0aa50c7@mail.gmail.com>
	 <20090818015504.GA29939@kroah.com>
	 <589ee1d0908181353o5a648242p702ec607b78c2e56@mail.gmail.com>
	 <20090818211946.GA23309@kroah.com>
Date: Wed, 19 Aug 2009 23:16:28 +0100
Message-ID: <589ee1d0908191516v173d448bt87f72a324284d92d@mail.gmail.com>
Subject: Re: Oops: sysfs: duplicate filename 'usbdev3.3_ep81' can not be 
	created
From: Christian Roche <christian.roche.fr@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In particular I get the following error :
>> > setserial /dev/ttyACM0
>> /dev/ttyACM0: Input/output error
>
> That's a different error.

Yes indeed, in fact the error was simply due to the fact that I needed
to modprobe usbserial before rather than after the switch. So it was
totally unrelated.

> That's some other problem.  It would be great if you could try out the
> 2.6.31-rc kernel as work has gone on in this area.

Well I'm willing to do that, however I think I'll have to wait until
they compile one 2.6.31 kernel for Fedora 11, because it looks like
currently I would have to totally mess up my installation to do that.
Since the whole issue is only a warning I guess this is not too much
of a problem, unless you deem it important in which case I'm ok to try
it.

Thanks a lot for your help !
Chris
