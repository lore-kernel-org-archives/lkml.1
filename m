Return-Path: <linux-kernel-owner+w=401wt.eu-S1763312AbXF1H7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763312AbXF1H7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 03:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761518AbXF1H7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 03:59:25 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:35175 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760434AbXF1H7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 03:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kCndVZXngyKYzbcc8ql9hfD65yUVhUXcSgw+3dE0BvHfDebANRS1x5foswrvonbxc7KtAe7mMoVGYE3UOeBaefkaDzVjp8qBxudd8A/oXxSaNALsr8DhuoZDv1SHFaU7MAAqnzLcO+Yt2A0qgGk7dmsfFEGmZyaSlTLyfmEFGkg=
Message-ID: <5486cca80706280059pabcaa59u7f44440134490590@mail.gmail.com>
Date: Thu, 28 Jun 2007 09:59:22 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: [Possible BUG] Logitech USB keyboard inconsistent led state
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706272144280.9610@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80706270758x540f75a9vfdd4aa5b6a7d8e4f@mail.gmail.com>
	 <Pine.LNX.4.64.0706272144280.9610@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/27, Jiri Kosina <jikos@jikos.cz>:
> On Wed, 27 Jun 2007, Antonino Ingargiola wrote:
>
> > I'm using a logitech USB keyboard, I think it's one of the most cheap
> > and diffuse logitech keyboard models.
> > I have an inconsistent led state. During boot the NumLock led blinks
> > several times and is on as boot finishes. However the numeric keypad
> > works as it was off (no numbers, keypad '.' works as Canc, '0' as Ins
> > and so on).
>
> Could you please send me vendor and product ids of the keyboard? I will
> send you a patch to test.

Sure, here it is:

$ cat /sys/bus/usb/devices/1-1.2/idVendor
046d
$ cat /sys/bus/usb/devices/1-1.2/idProduct
c311


Best regards,

    ~ Antonio
