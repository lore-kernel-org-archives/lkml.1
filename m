Return-Path: <linux-kernel-owner+w=401wt.eu-S1765557AbXF1UJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765557AbXF1UJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760720AbXF1UJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:09:04 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:14570 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926AbXF1UJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:09:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mywvXZq2JPO3DF8qgKbquhIFs+O72ryW9P0cyu0V3tAUYn/JQxsMYy9Pd7fW2CN/s9smMTEeQOvIoo89QJxDmUM80XOZYZYd+88bsuhYF2uOOTQRuAUZzOJTmTzhyK+hFv3Eprc6BiQalhrJzdCmZAEYOH48+D7Fhwq1P5neCTM=
Message-ID: <5486cca80706281309q473c6300l6bd221c361d3f5df@mail.gmail.com>
Date: Thu, 28 Jun 2007 22:09:01 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: [Possible BUG] Logitech USB keyboard inconsistent led state
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706281923230.31463@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80706270758x540f75a9vfdd4aa5b6a7d8e4f@mail.gmail.com>
	 <Pine.LNX.4.64.0706272144280.9610@twin.jikos.cz>
	 <5486cca80706280059pabcaa59u7f44440134490590@mail.gmail.com>
	 <Pine.LNX.4.64.0706281923230.31463@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/28, Jiri Kosina <jikos@jikos.cz>:
> On Thu, 28 Jun 2007, Antonino Ingargiola wrote:
>
> > $ cat /sys/bus/usb/devices/1-1.2/idVendor
> > 046d
> > $ cat /sys/bus/usb/devices/1-1.2/idProduct
> > c311
>
> Please try the patch below (against any post-2.6.22-rc1 kernel)

Tried on 2.6.22-rc6-cfs18 and it works, thanks :)

Now the led is off by default on boot but the state is consistent.

Can we have this patch in 2.6.22?

(Feel free to add a Tested off with my name is this make any sense in
this case).


Best Regards,

    ~ Antonio
